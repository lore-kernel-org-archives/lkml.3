Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaCFFG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:06:58 -0500
Received: from ozlabs.org ([203.10.76.45]:40499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaCFFG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:06:56 -0500
Date: Thu, 6 Mar 2014 16:06:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlNhbHZhIFBlaXLDsyI=?= <speiro@ai2.upv.es>,
        Daeseok Youn <daeseok.youn@gmail.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20140306160649.9564c40b8deaaf3b1e261a5b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_16_06_49_+1100_bgTIyogxybW49b_l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_16_06_49_+1100_bgTIyogxybW49b_l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/cxt1e1/linux.c between commit 084b6e7765b9
("staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl()")
from the staging.current tree and commit 922b81b835c4 ("staging: cxt1e1:
remove space between function name and parenthesis") and a couple of
others from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/cxt1e1/linux.c
index 79206cb3fb94,579e68e3dece..000000000000
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@@ -861,79 -876,78 +876,80 @@@ c4_ioctl(struct net_device *ndev, struc
  #endif
 =20
  #if 0
-     pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
-             _IOC_DIR (iocmd), _IOC_TYPE (iocmd), _IOC_NR (iocmd),
-             _IOC_SIZE (iocmd));
+ 	pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
+ 		_IOC_DIR(iocmd), _IOC_TYPE(iocmd), _IOC_NR(iocmd),
+ 		_IOC_SIZE(iocmd));
  #endif
-     iolen =3D _IOC_SIZE (iocmd);
-     if (iolen > sizeof(arg))
-         return -EFAULT;
-     data =3D ifr->ifr_data + sizeof (iocmd);
-     if (copy_from_user (&arg, data, iolen))
-         return -EFAULT;
-=20
-     ret =3D 0;
-     switch (iocmd)
-     {
-     case SBE_IOC_PORT_GET:
-         //pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
-         ret =3D do_get_port (ndev, data);
-         break;
-     case SBE_IOC_PORT_SET:
-         //pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
-         ret =3D do_set_port (ndev, data);
-         break;
-     case SBE_IOC_CHAN_GET:
-         //pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
-         ret =3D do_get_chan (ndev, data);
-         break;
-     case SBE_IOC_CHAN_SET:
-         //pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
-         ret =3D do_set_chan (ndev, data);
-         break;
-     case C4_DEL_CHAN:
-         //pr_info(">> C4_DEL_CHAN Ioctl...\n");
-         ret =3D do_del_chan (ndev, data);
-         break;
-     case SBE_IOC_CHAN_NEW:
-         ret =3D do_create_chan (ndev, data);
-         break;
-     case SBE_IOC_CHAN_GET_STAT:
-         ret =3D do_get_chan_stats (ndev, data);
-         break;
-     case SBE_IOC_LOGLEVEL:
-         ret =3D do_set_loglevel (ndev, data);
-         break;
-     case SBE_IOC_RESET_DEV:
-         ret =3D do_reset (ndev, data);
-         break;
-     case SBE_IOC_CHAN_DEL_STAT:
-         ret =3D do_reset_chan_stats (ndev, data);
-         break;
-     case C4_LOOP_PORT:
-         ret =3D do_port_loop (ndev, data);
-         break;
-     case C4_RW_FRMR:
-         ret =3D do_framer_rw (ndev, data);
-         break;
-     case C4_RW_MSYC:
-         ret =3D do_musycc_rw (ndev, data);
-         break;
-     case C4_RW_PLD:
-         ret =3D do_pld_rw (ndev, data);
-         break;
-     case SBE_IOC_IID_GET:
-         ret =3D (iolen =3D=3D sizeof (struct sbe_iid_info)) ? c4_get_iidi=
nfo (ci, &arg.u.iip) : -EFAULT;
-         if (ret =3D=3D 0)               /* no error, copy data */
-             if (copy_to_user (data, &arg, iolen))
-                 return -EFAULT;
-         break;
-     default:
-         //pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
-         ret =3D -EINVAL;
-         break;
-     }
-     return mkret (ret);
+ 	iolen =3D _IOC_SIZE(iocmd);
++	if (iolen > sizeof(arg))
++		return -EFAULT;
+ 	data =3D ifr->ifr_data + sizeof(iocmd);
+ 	if (copy_from_user(&arg, data, iolen))
+ 		return -EFAULT;
+=20
+ 	ret =3D 0;
+ 	switch (iocmd)
+ 	{
+ 	case SBE_IOC_PORT_GET:
+ 		//pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
+ 		ret =3D do_get_port(ndev, data);
+ 		break;
+ 	case SBE_IOC_PORT_SET:
+ 		//pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
+ 		ret =3D do_set_port(ndev, data);
+ 		break;
+ 	case SBE_IOC_CHAN_GET:
+ 		//pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
+ 		ret =3D do_get_chan(ndev, data);
+ 		break;
+ 	case SBE_IOC_CHAN_SET:
+ 		//pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
+ 		ret =3D do_set_chan(ndev, data);
+ 		break;
+ 	case C4_DEL_CHAN:
+ 		//pr_info(">> C4_DEL_CHAN Ioctl...\n");
+ 		ret =3D do_del_chan(ndev, data);
+ 		break;
+ 	case SBE_IOC_CHAN_NEW:
+ 		ret =3D do_create_chan(ndev, data);
+ 		break;
+ 	case SBE_IOC_CHAN_GET_STAT:
+ 		ret =3D do_get_chan_stats(ndev, data);
+ 		break;
+ 	case SBE_IOC_LOGLEVEL:
+ 		ret =3D do_set_loglevel(ndev, data);
+ 		break;
+ 	case SBE_IOC_RESET_DEV:
+ 		ret =3D do_reset(ndev, data);
+ 		break;
+ 	case SBE_IOC_CHAN_DEL_STAT:
+ 		ret =3D do_reset_chan_stats(ndev, data);
+ 		break;
+ 	case C4_LOOP_PORT:
+ 		ret =3D do_port_loop(ndev, data);
+ 		break;
+ 	case C4_RW_FRMR:
+ 		ret =3D do_framer_rw(ndev, data);
+ 		break;
+ 	case C4_RW_MSYC:
+ 		ret =3D do_musycc_rw(ndev, data);
+ 		break;
+ 	case C4_RW_PLD:
+ 		ret =3D do_pld_rw(ndev, data);
+ 		break;
+ 	case SBE_IOC_IID_GET:
+ 		ret =3D (iolen =3D=3D sizeof(struct sbe_iid_info)) ?
+ 		       c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
+ 		if (ret =3D=3D 0)               /* no error, copy data */
+ 			if (copy_to_user(data, &arg, iolen))
+ 				return -EFAULT;
+ 		break;
+ 	default:
+ 		//pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
+ 		ret =3D -EINVAL;
+ 		break;
+ 	}
+ 	return mkret(ret);
  }
 =20
  static const struct net_device_ops c4_ops =3D {

--Signature=_Thu__6_Mar_2014_16_06_49_+1100_bgTIyogxybW49b_l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGAJtAAoJEMDTa8Ir7ZwVhUQP/1oCtlChnn/hJRXdela+gl6N
qEGwoJHVVB6IxHN24HVcLYKD0IOEnQKJwD2IYxfZB4fzXEqsv7ShCjRskqfn18na
wZuznMHFy5XZDHFhBkC4VtTtnSfHC/0KUDySuPjH3OjSrnYSUZ5A/1MxdUIyVoUs
flQOW1gexNvpc//8x6j6IUiljgRDLc0C3kpuFuYV3n2BINK7ONtsNRz/uoi1JVLj
vGXRpl6TOxDS01oxTX5q24pkhDOPUUAJw+ZBazt84PWZdATtUmO/kUOHAjo2AyX1
3W1Ow3yjEfk9sY6lap70/MGtgTxl1wFZwJQldyxC8ajDdCMBIkZ7zVss8EKmDxw3
5MvvRSGhEK0TgiNoDMUYKFHubrhl4nzKmye/fVAb9YVGYsaLDn1zUpHAAdlmjqkU
t+cJLNiWkkNyai2bLJC78PhvdTjX9bPAX0W7Pi+Hi5k5sgDgKh8KUSwTPe1MkAxA
YQlArQftHtIpogepRqncI2rf0HNoYN1IRsikiXnj8+r5jcH4l9675aO9ZIsPj54u
Ysya8jz6LWN10nwAge1ztGhwU68vyf2RPupn5iR7o51VQmtAWWaVlLhzWHeS+sIn
JjJY84N9XXxWkFXKkV6meROfC5M1GvVcK6rVeJ+VwY0SQSQntr/jXlDUtz005OIE
FvzQTZWQV0I1jw22o+vU
=zuKG
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_16_06_49_+1100_bgTIyogxybW49b_l--
