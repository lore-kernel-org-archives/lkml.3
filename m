Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3ITNBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:01:35 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:58851 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3ITNBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:01:34 -0400
Message-ID: <1379682015.9746.3.camel@oban>
Subject: Re: [PATCH v2 0/3] Fix Win8 backlight issue
From: Yves-Alexis Perez <corsac@debian.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Fri, 20 Sep 2013 15:00:15 +0200
In-Reply-To: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-15JMR/uvGZvL3AygEp60"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-15JMR/uvGZvL3AygEp60
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> v1 has the subject of "Rework ACPI video driver" and is posted here:
> http://lkml.org/lkml/2013/9/9/74
> Since the objective is really to fix Win8 backlight issues, I changed
> the subject in this version, sorry about that.
>=20
> This patchset has three patches, the first introduced a new API named
> backlight_device_registered in backlight layer that can be used for
> backlight interface provider module to check if a specific type
> backlight
> interface has been registered, see changelog for patch 1/3 for
> details.
> Then patch 2/3 does the cleanup to sepeate the backlight control and
> event delivery functionality in the ACPI video module and patch 3/3
> solves some Win8 backlight control problems by avoiding register ACPI
> video's backlight interface if:
> 1 Kernel cmdline option acpi_backlight=3Dvideo is not given;
> 2 This is a Win8 system;
> 3 Native backlight control interface exists.

I've tested this on my x230 (using pure UEFI with CSM disabled). As far
as I can tell, it works as I would expect:

- brightness keys work in initramfs, in console after boot, in lightdm
prompt and in Xfce (wether or not xfce4-power-manager is running).

I don't have brightness notifications (from xfce4-power-manager) but I
don't usually need them so I'm fine with that.

Regards,
--=20
Yves-Alexis

--=-15JMR/uvGZvL3AygEp60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABCAAGBQJSPEbfAAoJEG3bU/KmdcClZxwH/1p/b8ooRZyWt7n+FZufMER3
665uuKlwgxRmd44M7XoN9M0IIGbNm6srEReA1OEF1lRnhzJLS4fGYXrcAAExheCV
vA8Lk15FJlF7XjLVqtQGw3G0BjovolIB5XQCq9F3gom//liAYlhXOnH4sJMSFgu5
/vP8C+BtpBusxow6JQIMD7UvTpCWpM6ImMC/C3Dj38UxtuPlEx5XbuufU1mnxpSe
qs7nUoFhKP6/Dcp+HQuzCBpKdAQQzgGcr0c74UeTq2MA+vTTgFezQsDExV+LTxQ/
DvKV9J0ChDxUR8PDwC/rMRvu/QghukoGoHCT90V0+ubBMVOMdHJWsFKT59cAt9c=
=ctoj
-----END PGP SIGNATURE-----

--=-15JMR/uvGZvL3AygEp60--

