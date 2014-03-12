Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaCLBdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:33:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44877 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbaCLBdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:33:10 -0400
Date: Wed, 12 Mar 2014 01:32:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>,
        Salva =?ISO-8859-1?Q?Peir=F3?= <speiro@ai2.upv.es>,
        Daeseok Youn <daeseok.youn@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312013259.d374b64c0655e98612d880b3@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_01_32_59_+0000_8Cb6YRmElvMM_1wV"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the staging tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_01_32_59_+0000_8Cb6YRmElvMM_1wV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in drivers/stag=
ing/cxt1e1/linux.c between commit 084b6e7765b95 ("staging/cxt1e1/linux.c: C=
orrect arbitrary memory write in c4_ioctl()") from Linus' tree and commit a=
a562fa70931d ("staging: cxt1e1: Fix no spaces at the start of a line in lin=
ux.c") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/staging/cxt1e1/linux.c
index 79206cb3fb94,549efd1fa965..000000000000
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@@ -861,79 -867,77 +867,79 @@@ c4_ioctl(struct net_device *ndev, struc
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
+ 	switch (iocmd) {
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

--Signature=_Wed__12_Mar_2014_01_32_59_+0000_8Cb6YRmElvMM_1wV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH7lLAAoJELSic+t+oim9JuEQAJf02sFaOxefD+GCCwP0jioA
p79dR4BPde/S9k/xNh/16giX7yN4NwokmTwKRLppQAKi9MZVKsRlxDtobAeScaDT
KOiTBZHOiC13iq+/0aneJE3CvbGxru/80zDJR9wt0pOtxBKyvck0n6D5pf4x/6WR
8y1I7HWm23uj6EVGXsXnpNRNv/EIpT+Cu7BIiyiXhjQjhOOWXxL8kKQ/RaCwxBBF
uBY3423b0ERf8JAUldTsA3yv0DCDQQaqCZ/QMU7zBGHi7JKV8p3BezYPnaCgbXFw
EZ8nkLrOamTQvVxVCEJFrA18i6GOQjLU6W5x0CEEMnYZCUaCulY0VgG8xAI+vSVx
dlQ1KQ5W2Oj2+vx93S2/AAE9iwlS0+yPifQEBJZcZVWzcDrNcSo4qz6598iE/VAP
EPz64IqnxmHPXNyoTM9XdVODHeEj+KuBRbYwtGliLjBprglUAbG807jMojgj+eF4
QxVt+JLjU7QuHKoJQJYcC6L33inms266PnkmOyIteCG87SYbjCY6GCHWExZulRkJ
Kw0TUJGCHbh/6o2FKy5vek1aXVTQ1IkPSbs+lBGO/WO7jZgHf++NkJUT+Bq6J+0L
kTrx2cteOlZC6VnFqRh3tJj9ejOU2jaPTY3jhdNPx6/mt6s1Q0lQO2OucJdWqC9k
XpaxUQ+ShZ7zdqHvPJBl
=5KJo
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_01_32_59_+0000_8Cb6YRmElvMM_1wV--
