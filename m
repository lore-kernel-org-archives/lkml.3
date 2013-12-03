Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3LCMfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:35:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53453 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3LCMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:35:31 -0500
Date: Tue, 3 Dec 2013 12:34:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Li Xiubo <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Fabio Estevam <Fabio.Estevam@freescale.com>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131203123459.GS27568@sirena.org.uk>
References: <1385621219-20652-1-git-send-email-Li.Xiubo@freescale.com>
 <20131129183855.GI27568@sirena.org.uk>
 <1DD289F6464F0949A2FCA5AA6DC23F828E3D21@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2BgGqEnop8iZnuR"
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F828E3D21@039-SN2MPN1-011.039d.mgd.msft.net>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: SGTL5000: Fix kernel failed while trying to get
 optional VDDD supply.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2BgGqEnop8iZnuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 09:49:47AM +0000, Li Xiubo wrote:

> 2, If the regulator dt node is exist but the optional VDDD is absent (i.e.
> The external VDDD is not used), a -EPROBE_DEFER will be returned, if just
> return the -EPROBE_DEFER to the probe(and then the probe deferral
> mechanism will do the probe again later, is that right ?), and then the
> regulator_get_optional() will be called later again, and the -EPROBE_DEFER
> will be returned again too, and now how should I handle -EPROBE_DEFER error
> twice ? Or should there be a counter about this ? That to say when the
> -EPROBE_DEFER error is the second time returned from regulator_get_optional()
> can we ensure that the optional VDDD is really not in use.

The driver should just defer when it's told to defer, I don't understand
why it would want to count anything?

--s2BgGqEnop8iZnuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnc/wAAoJELSic+t+oim96FsP/3OVW9cWGacoOZg++GTnt4oY
+XsSLti7BjdMkbFAYutczbktHhVvWCGFd0HdlAF/X4YhLdr8DZ5Clx9G/aY34WWz
65LOwPYnvbxWqgSUf7hE44959Vsi6cufS0pEM1JmWnjtUJIkphfeIjEwFGfy42m4
RyyJ1ozHimuCXeFfv9LtgYjo1lzW0gwiz+g0tup9tgrBAYQD8gBK5515Hotyibs4
AvnzFEKMyfEDhJlSzoF54PeuO9I0/VAufCyZBWysuQPspll7dtVMTjGkN5IzySkt
X6s6Pdh1axtrGEN30RdKKqkTQ1beZj0V9LyyBRzrfj64Wzlz0VNJZLYt2XVEsfpj
JjPDVJlH8xWh4SZrOxm9anDJq255XpjUQmC+RzfLFEJtfdou7u6MmCPONaJ1pyHl
gLAh23G2v1HnOlwQZmmvvQK4CaC3TFSR+TAANtis9gOx2Z1vok87brPRh5WAh4O8
TagD6ajHkPOEtFYSzHPwdfQ5GbQ/XUAn36yRjUi3xs6iLNtbQjraLAjyLfb/Je6c
goDPmYptTYoibd6kxvqhVcAQJ+t5N/sDb5fHVGNX7FDXUpoS56S5rA8/eDXHdCpn
zyUNpWXXMgclpBLKscvQ07B16WSQnkuK0id+fhRXeVO4ljKene6XBEOkzQfMR6QX
91NcVaatbcVu+inXLvRV
=6hMD
-----END PGP SIGNATURE-----

--s2BgGqEnop8iZnuR--
