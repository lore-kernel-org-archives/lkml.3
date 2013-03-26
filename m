Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3CZXwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:52:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52709 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3CZXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:52:51 -0400
Date: Wed, 27 Mar 2013 10:52:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (v4l-dvb tree related)
Message-Id: <20130327105234.3396059519ca69f405f703b1@canb.auug.org.au>
In-Reply-To: <20130326090452.01550c37@redhat.com>
References: <20130326171847.18cd41b85d3caee6373d9447@canb.auug.org.au>
	<20130326090452.01550c37@redhat.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_10_52_34_+1100_1_CqcDLgA7MyMc4m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_10_52_34_+1100_1_CqcDLgA7MyMc4m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Tue, 26 Mar 2013 09:04:52 -0300 Mauro Carvalho Chehab <mchehab@redhat.co=
m> wrote:
>
> Em Tue, 26 Mar 2013 17:18:47 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
>=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c: In function 'solo_e=
nc_default':
> > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1031:7: error: case =
label does not reduce to an integer constant
> > drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1035:7: error: case =
label does not reduce to an integer constant
> >=20
> > I am not sure why this has suddenly appeared, but I have disabled the
> > driver for now using this patch:
>=20
> Well, solo6x10 didn't use to have its own private ioctl's until now.
> Still, that's strange, as there are other drivers also using vidioc_defau=
lt.
>=20
> I suspect that those _IO* have its highest bit equal to 1 on powerpc
> being too big for int. If so, the enclosed patch should fix.=20
> I'm still wandering why it didn't cause any compilation problems here.
>=20
> Ok, I didn't try to compile it on powerpc, but still integers have 32
> bits on ppc, right?

yes.

> Anyway, could you please try the enclosed patch?

Doesn't help.

on powerpc, SOLO_IOC_G_MOTION_THRESHOLDS expands to

(((2U) << (((0 +8)+8)+13)) | ((('V')) << (0 +8)) | (((192 +0)) << 0) | ((((=
(sizeof(struct solo_motion_thresholds) =3D=3D sizeof(struct solo_motion_thr=
esholds[1]) && sizeof(struct solo_motion_thresholds) < (1 << 13)) ? sizeof(=
struct solo_motion_thresholds) : __invalid_size_argument_for_IOC))) << ((0 =
+8)+8)))

sizeof(struct solo_motion_thresholds) is 64*64*2 =3D=3D 8192 which is not
less than 1 << 13

:-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_10_52_34_+1100_1_CqcDLgA7MyMc4m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUjTCAAoJEECxmPOUX5FEjhoP/16X4+HCgNo4147pe5SVu3uM
haOCFMYPzcrlx0TujA2+cqYdMM4pZ4qNvvFCxWlDdEnvg+6luJsYCEKhAkrrFemv
WlmTgdpnURAFb7pCPiR6OvE7NbniaAazHN8fI+acZfklbk5w2ZxEHkGTmnbS4SdT
PibNS+Vo9mV/GXFWH9AnrBFRhyNEXpmPjYTm4471Se6NciINP1PvoWradwrkDMtE
3P8XKVE5JzE+42FTZKsCxizyXVtZdX+wW5C79AUSizMbHt39l+DCkfz+M7Ff/4UP
A/VNFdDelPdP0NWfyp5BozW9HlJAs1y2iVA43RHUs8f8+qPZ6uMysRTLUcnAmqZD
qa46vIjYIvLqzEiTgRUDidwaZvi4wX3/Pfo2yywPcgL7Ys1uRO4PNy0NY2sMOXQc
piYLAjGQBUQLwjSesiefPsva7aoAPQa6rRozhuykKbrOLg3qye5Ok9H8T7cOA1yh
sZeKwnrvaGtZNbDSs9n+4BQ262sji6WNoU9FdajAeWTNyt7qmb+XEqyAOnOU1das
BxBHdFhthIJOOMxuMoHb4dzr0k8ZkHCTVi+0GAa4gQtAjsC4zWIo4PxR8scmlfLG
dTX6eQpKmtDQ/5Q1eaqseNp7cKUb80X6D6F8V4ibxjPRjeZo/pD0ot8O54wVOoAw
Fxa135WnbCUPu+tzRl2R
=5yYz
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_10_52_34_+1100_1_CqcDLgA7MyMc4m--
