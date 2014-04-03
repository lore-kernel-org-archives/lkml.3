Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbaDCDNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 23:13:12 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48957 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbaDCDNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 23:13:10 -0400
From: James Hogan <james@albanarts.com>
To: Jani Nikula <jani.nikula@intel.com>, Imre Deak <imre.deak@intel.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: drm/i915: XPS13 backlight regression in v3.14
Date: Thu, 03 Apr 2014 04:12:58 +0100
Message-ID: <2613018.1cXJgVWlHm@radagast>
User-Agent: KMail/4.11.5 (Linux/3.14.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1540737.b7YM2oHPVp"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1540737.b7YM2oHPVp
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I've noticed that v3.14 breaks the backlight on Dell XPS13. Reverting the 
following commit fixes the issue for me (i.e. the GUI brightness controls work 
again):

bc0bb9fd1c78 drm/i915: remove QUIRK_NO_PCH_PWM_ENABLE

It appears that in v3.14 (with the above patch):
* intel_backlight/brightness=4882 (max & default) causes 
acpi_video0/brightness to have no effect.
* intel_backlight/brightness=0 causes acpi_video0/brightness to behave 
corrrectly (the firmware (I assume) fades the brightness gradually when 
acpi_video0/brightness is set)
* intel_backlight/brightness=something else in between often causes 
acpi_video0 and intel_backlight to apparently "fight" over the backlight, 
resulting in brightness flickering up and down every second or so.

Reverting the above patch on v3.14:
* intel_backlight/brightness has no effect
* acpi_video0/brightness works normally

It doesn't seem quite as simple as them trying to use the same hardware since 
when intel_backlight/brightness=4882, acpi_video0/brightness has no effect at 
all, so I don't really get what's going on.

Can anybody shed some light or suggest a proper fix for this recurring issue?

Thanks
James
--nextPart1540737.b7YM2oHPVp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTPNHCAAoJEGwLaZPeOHZ66tMP+gOV3J4/bQWI+6TBHVAX9Z5N
+HA8/zijmRo0X8Jkaeg2f9MRMdWY4GycmSEcS2dvrOLLd+Tgfj1k7rK9zdNQiGq4
b3ufjEnSZU59Ysm7q0I0YfZaRDxUZkZ5gRse4P1Z9htY8/Ip75caTC66LSnU7T80
yFZTQJfuAHJ7TjPHzo84my7cP5NPwfzj+9FrYB8bmejSDvPd8rXcMckF30LsFYYf
TgMJ6MrDdyEeQY3aWw2gp2I3KgKpP3rQF8vXs4Q9Fqbx2jPpKqoseXraTzD90RXu
2F4kTbqKXXApHPfAq446ZemB/PXMxxxHoysfeByJSt+JeloxvhUuUPmVp4MrMbpR
nolCv+gtv36rVQh37+V+KKJS94Zo8TUC6Q+Z1tpqZ3RQjnlIGoniq5BsDDx6Q5xg
2H5FNJbP5KfKH2LLX3E0xWO0u24uPiEuVmthzSit2YnzqxajfcZiszXRxRME5Cfi
S+9VCv53hTpF7IiSRLb/9L4EPFu9oj95HN8iAhPYm5yhieWtuoKd0I8fWpqnl+My
EVDTfyAsKXMzzGyoY2KcrgB2QXfTS0toQnRrcoTjLxnAhD1HsLmnw0ZsiVYSULbt
4c5d+9grYSCu+dqZ6vAy4TdNsY+762N0oCTL6qqUjnTqEfuQGdUg2k0YE5CGtG0e
6MevAiqSgtfPbAE4nnzy
=8Mlo
-----END PGP SIGNATURE-----

--nextPart1540737.b7YM2oHPVp--

