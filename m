Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab3AQKJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:09:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44446 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486Ab3AQKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:09:30 -0500
Date: Thu, 17 Jan 2013 12:09:19 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, Luciano Coelho <coelho@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130117100919.GJ10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
 <50F7C4A7.5060202@ti.com>
 <20130117093417.GH10814@arwen.pp.htv.fi>
 <50F7CA82.4050509@ti.com>
 <20130117100510.GI10814@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Content-Disposition: inline
In-Reply-To: <20130117100510.GI10814@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 12:05:10PM +0200, Felipe Balbi wrote:
> Hi,
>=20
> On Thu, Jan 17, 2013 at 10:55:14AM +0100, Peter Ujfalusi wrote:
> > On 01/17/2013 10:34 AM, Felipe Balbi wrote:
> > >> I just wonder how this is going to work with DT... You are not going=
 to have
> > >> the ability to use callback in this form.
> > >> I think the GPIO handling should be done in the driver itself rather=
 than in
> > >> the board file.
> > >=20
> > > that can (should ?) be moved to ti-st eventually. In fact I don't know
> > > why it was removed in the first place, we would need Pavan to help us
> > > with that query.
> >=20
> > Yes, this is a good question. I don't know what is the spacial thing pl=
atforms
> > need to do in the callback..

hah! looks like I found the reason:

http://git.omapzoom.org/?p=3Dkernel/omap.git;a=3Dblob;f=3Darch/arm/mach-oma=
p2/board-44xx-54xx-connectivity.c;h=3De4852b93e91b6daa8f85cca91a1e7fbcc778f=
45b;hb=3D594aedd9e7da0491523411f8999efd98297f4fe4#l177

IMHO:

a) removing gpio handling wasn't necessary, we could just check
	if gpio_is_valid(nshutdown_gpio)

b) that whole omap_serial_ext_uart_enable() looks really hacky. I'm sure
	we can come up with something better.

--=20
balbi

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ983PAAoJEIaOsuA1yqREXkUP/0DaXdUD8vAOEHw2PRroYUbD
IyTpShnnv3PJJMsVr64gxAHMkDDRDnq5YUkwoJLqKRDeT0W/9Vl2gZcy8l6lWzNM
1nBlCwJP2+3mjWN+/qzo3NnmErnT2FXuoXmts8luPFABU3aBYA2Bdvziip3Z7ZwK
9NamI3LboBeGezLX3OotvnxSGYxrqhHN3U11+1o6iuBUPeW566Fz8kbHJrJSvb8h
72fvPdzCIX9MeS2jupOKFM2o7WZtWx/36m9YGRE7+qX+3PhlpYkt3ozG0vujHAKo
nZKuZO28LuYHRSCaGSZ06OBFRCHkL/MCOPmGeEZZ/rdXtBoc03wpww5jyMLgWMh+
8gYLHRVy1Pf4zlBDYgRUuCeSBOdNtuFJ/lVXPkGs0c5xDf3AFf2zzM/6OMBcJOOu
MM6Hopebpom6rmK/P54fB22/Pwki0VYuCSD+JCfMkJg66c2v/+TW9dckNgjpMSQ9
EUe1GFFbOhRtX3aHqUy6fSx/reANmmP76tqPIg6FShxq4/BaySNfc/H6pVAYa1iu
tr0Hr3e0l+94D25POMn5qyNvYMXNO3j9V1nLoV3Fjn621dq0iO6FD14t44R0Zyub
xR85lvirhB342OKgZ7L5r1eE0mUXhrHEqUMNavq3VpiWs9EHUoiHKt//Hi7HEaHM
VEBiB6U/8a3YDcl1aD8V
=5lZo
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
