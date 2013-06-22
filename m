Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3FVVsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:48:18 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:56324 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3FVVsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:48:14 -0400
Message-ID: <1371937599.17761.19.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Sat, 22 Jun 2013 23:46:39 +0200
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-AgAW02ounmx25Kp58XH6"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AgAW02ounmx25Kp58XH6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On dim., 2013-06-09 at 19:01 -0400, Matthew Garrett wrote:
> The first two patches in this series are picked from other patchesets aim=
ed at
> solving similar problems. The last simply unregisters ACPI backlight cont=
rol
> on Windows 8 systems when using an Intel GPU. Similar code could be added=
 to
> other drivers, but I'm reluctant to do so without further investigation a=
s
> to the behaviour of the vendor drivers under Windows.

Hi,

I've read this thread coming from
https://bugzilla.kernel.org/show_bug.cgi?id=3D51231 and tried the patches
on a Lenovo ThinkPad X230 with intel graphics.

The problem with thoses fixes is that they still introduce a regression
in how the brightness is handled, at least for me.

Before Linux support for acpi_osi("Windows 2012") (and when booting with
acpi_osi=3D"!Windows 2012"), brightness keys were handled by the kernel
just fine, whether in console, in the display manager or in my desktop
environment (Xfce). xfce4-power-manager just needs to be told that the
brightness keys are already handled and it doesn't need to do anything.

After Linux started responding to Win8 ACPI checks, it somehow broke,
but not completely. Brightness keys are not handled by the kernel
anymore (so no brightness adjustment in console or without a hotkey
daemon running). If I run xfce4-power-manager and tell it to handle the
brightness keys, it does work (although the number of brightness levels
is not completely right). That means both acpi_video0 and
intel_backlight backlight interfaces work, they just don't have the same
precision and max_brightness (more details on the bug).

When adding those three patches, well, acpi_video0 is removed (as
intended), but I still don't have brightness handling in the kernel and
need to have something handling it in userspace.

I really think this is a bad idea. In some cases it might be the only
solution, but having a place where this is set consistently would be
really best, imho. Every userspace daemon might do things differently,
and not everyone even has it. And I'm really not sure brightness keys
should be handled by a desktop environment anyway.

So can the previous behavior be actually restored? Maybe it was easier
to pass the brightness keys information from thinkpad_acpi.ko to
video.ko than it is to i915.ko but since it goes to the input layer
anyway I guess it could be fed to module handling that in a way or
another?

Please keep me on CC: on replies, I'm not subscribed to the various
lists.

Regards,
--=20
Yves-Alexis

--=-AgAW02ounmx25Kp58XH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJRxhs/AAoJEG3bU/KmdcClfigIAJo9VVCD8QHluU5qX4JOb+aM
sA0t+wX6RIWfgPFC9CrhYQbLIk3ceyGA17SH2+PQPQM5HVsfmM1nqg4Pk9saXUt3
OgTiaBzsNtQ9iSpMkOo7qX0lg+8I/mRPctVcSqx8q8oxksvhuMso5f5ISGkv7K1w
qk1k40dWnCNVVmtR7VIw+dwLrZUNprGbZQrWtBBxyxDUYcw8zELEqNPYlzOQUNj8
sTCJNeUfl3FpNFAj1yIRGP6T7+jsUP+4ZDjG3QKajfTRuRxC+bDl+F0lTXJAliJL
xZDgM014rIwYrbOS65oQj1Je8IYr1PkPUvlGjeNK8mdovkPxNxP0YxtwpPvXJQk=
=mMWA
-----END PGP SIGNATURE-----

--=-AgAW02ounmx25Kp58XH6--
