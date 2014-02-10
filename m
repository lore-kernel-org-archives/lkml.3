Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaBJEyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:54:22 -0500
Received: from ozlabs.org ([203.10.76.45]:45593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaBJEyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:54:20 -0500
Date: Mon, 10 Feb 2014 15:54:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20140210155412.d42b2dda36feac3e9c8733fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Feb_2014_15_54_12_+1100_Itl8SJ67dqJbfMsM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Feb_2014_15_54_12_+1100_Itl8SJ67dqJbfMsM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/rtl8188eu/core/rtw_mlme.c: In function '_rtw_init_mlme_priv=
':
drivers/staging/rtl8188eu/core/rtw_mlme.c:65:2: error: implicit declaration=
 of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  pbuf =3D vzalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)));
  ^
drivers/staging/rtl8188eu/core/rtw_mlme.c:65:7: warning: assignment makes p=
ointer from integer without a cast [enabled by default]
  pbuf =3D vzalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)));
       ^
drivers/staging/rtl8188eu/core/rtw_mlme.c: In function '_rtw_free_mlme_priv=
':
drivers/staging/rtl8188eu/core/rtw_mlme.c:133:4: error: implicit declaratio=
n of function 'vfree' [-Werror=3Dimplicit-function-declaration]
    vfree(pmlmepriv->free_bss_buf);
    ^
drivers/staging/rtl8188eu/core/rtw_mp.c: In function '_rtw_mp_xmit_priv':
drivers/staging/rtl8188eu/core/rtw_mp.c:946:3: error: implicit declaration =
of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(pxmitpriv->pallocated_xmit_extbuf);
   ^
drivers/staging/rtl8188eu/core/rtw_mp.c:959:2: error: implicit declaration =
of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  pxmitpriv->pallocated_xmit_extbuf =3D vzalloc(num_xmit_extbuf * sizeof(st=
ruct xmit_buf) + 4);
  ^
drivers/staging/rtl8188eu/core/rtw_mp.c:959:36: warning: assignment makes p=
ointer from integer without a cast [enabled by default]
  pxmitpriv->pallocated_xmit_extbuf =3D vzalloc(num_xmit_extbuf * sizeof(st=
ruct xmit_buf) + 4);
                                    ^
drivers/staging/rtl8188eu/core/rtw_recv.c: In function '_rtw_init_recv_priv=
':
drivers/staging/rtl8188eu/core/rtw_recv.c:80:2: error: implicit declaration=
 of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  precvpriv->pallocated_frame_buf =3D vzalloc(NR_RECVFRAME * sizeof(union r=
ecv_frame) + RXFRAME_ALIGN_SZ);
  ^
drivers/staging/rtl8188eu/core/rtw_recv.c:80:34: warning: assignment makes =
pointer from integer without a cast [enabled by default]
  precvpriv->pallocated_frame_buf =3D vzalloc(NR_RECVFRAME * sizeof(union r=
ecv_frame) + RXFRAME_ALIGN_SZ);
                                  ^
drivers/staging/rtl8188eu/core/rtw_recv.c: In function '_rtw_free_recv_priv=
':
drivers/staging/rtl8188eu/core/rtw_recv.c:132:3: error: implicit declaratio=
n of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(precvpriv->pallocated_frame_buf);
   ^
drivers/staging/rtl8188eu/core/rtw_sta_mgt.c: In function '_rtw_init_sta_pr=
iv':
drivers/staging/rtl8188eu/core/rtw_sta_mgt.c:82:2: error: implicit declarat=
ion of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  pstapriv->pallocated_stainfo_buf =3D vzalloc(sizeof(struct sta_info) * NU=
M_STA + 4);
  ^
drivers/staging/rtl8188eu/core/rtw_sta_mgt.c:82:35: warning: assignment mak=
es pointer from integer without a cast [enabled by default]
  pstapriv->pallocated_stainfo_buf =3D vzalloc(sizeof(struct sta_info) * NU=
M_STA + 4);
                                   ^
drivers/staging/rtl8188eu/core/rtw_sta_mgt.c: In function '_rtw_free_sta_pr=
iv':
drivers/staging/rtl8188eu/core/rtw_sta_mgt.c:211:4: error: implicit declara=
tion of function 'vfree' [-Werror=3Dimplicit-function-declaration]
    vfree(pstapriv->pallocated_stainfo_buf);
    ^
drivers/staging/rtl8188eu/core/rtw_xmit.c: In function '_rtw_init_xmit_priv=
':
drivers/staging/rtl8188eu/core/rtw_xmit.c:94:2: error: implicit declaration=
 of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  pxmitpriv->pallocated_frame_buf =3D vzalloc(NR_XMITFRAME * sizeof(struct =
xmit_frame) + 4);
  ^
drivers/staging/rtl8188eu/core/rtw_xmit.c:94:34: warning: assignment makes =
pointer from integer without a cast [enabled by default]
  pxmitpriv->pallocated_frame_buf =3D vzalloc(NR_XMITFRAME * sizeof(struct =
xmit_frame) + 4);
                                  ^
drivers/staging/rtl8188eu/core/rtw_xmit.c:132:32: warning: assignment makes=
 pointer from integer without a cast [enabled by default]
  pxmitpriv->pallocated_xmitbuf =3D vzalloc(NR_XMITBUFF * sizeof(struct xmi=
t_buf) + 4);
                                ^
drivers/staging/rtl8188eu/core/rtw_xmit.c:174:36: warning: assignment makes=
 pointer from integer without a cast [enabled by default]
  pxmitpriv->pallocated_xmit_extbuf =3D vzalloc(num_xmit_extbuf * sizeof(st=
ruct xmit_buf) + 4);
                                    ^
drivers/staging/rtl8188eu/core/rtw_xmit.c: In function '_rtw_free_xmit_priv=
':
drivers/staging/rtl8188eu/core/rtw_xmit.c:262:3: error: implicit declaratio=
n of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(pxmitpriv->pallocated_frame_buf);
   ^
drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c: In function 'rtw_IOL_cmd=
_tx_pkt_buf_dump':
drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c:368:2: error: implicit de=
claration of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  u8 *pbuf =3D vzalloc(data_len+10);
  ^
drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c:368:13: warning: initiali=
zation makes pointer from integer without a cast [enabled by default]
  u8 *pbuf =3D vzalloc(data_len+10);
             ^
drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c:390:3: error: implicit de=
claration of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(pbuf);
   ^
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c: In function 'rtw_wx_set_pri=
v':
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c:5651:2: error: implicit decl=
aration of function 'vmalloc' [-Werror=3Dimplicit-function-declaration]
  ext =3D vmalloc(len);
  ^
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c:5651:6: warning: assignment =
makes pointer from integer without a cast [enabled by default]
  ext =3D vmalloc(len);
      ^
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c:5656:3: error: implicit decl=
aration of function 'vfree' [-Werror=3Dimplicit-function-declaration]
   vfree(ext);
   ^
drivers/staging/rtl8188eu/os_dep/usb_intf.c: In function 'rtw_usb_if1_init':
drivers/staging/rtl8188eu/os_dep/usb_intf.c:649:21: error: implicit declara=
tion of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  padapter =3D (struct adapter *)vzalloc(sizeof(*padapter));
                     ^
drivers/staging/rtl8188eu/os_dep/usb_intf.c:649:13: warning: cast to pointe=
r from integer of different size [-Wint-to-pointer-cast]
  padapter =3D (struct adapter *)vzalloc(sizeof(*padapter));
             ^
drivers/staging/rtl8188eu/os_dep/usb_intf.c:749:4: error: implicit declarat=
ion of function 'vfree' [-Werror=3Dimplicit-function-declaration]
    vfree(padapter);
    ^

Caused by commits 2397c6e09276 ("staging: r8188eu: Remove wrappers around
vmalloc and vzalloc") and 03bd6aea7ba6 ("staging: r8188eu: Remove
wrappers around vfree") from the staging tree.  See Rule 1 in
Documentation/SubmitChecklist ...

I have disabled that driver for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Feb_2014_15_54_12_+1100_Itl8SJ67dqJbfMsM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+Ft6AAoJEMDTa8Ir7ZwVE5oQAIHDcF/KqWDQlpAtJqBG77FC
q6vpMAbF/xrPkqPwsFbNMWVfer2PITuGePpDC2BI79cRPa8Ko09Tn/bOp2Ez7Ndo
aKvyrRi4rdS2exQVe1kEStxVr+tq6L1CG6MMY2kQlD6qUpy8zs8kKPUWfayXvQ7I
Z5Cf/w4mNVVdclfdTLENV/DhLeM3guoHFPuC9aJbt+fiNSJFzMCmRFLxgwyHdRwT
lINNpu9DvlHtt+yaZJcU082I5sPV6tgoA1fhVTTAsMf7c4RZR/smg3blldPaYJcV
c20geGqPyj0Rpr4L3j9c2fAg42kx47OkYd+yr3tUsnSJoshr1+Bl+t9GJCDAteMB
iHlkM3B/s1gZOAKcNj1jY5vv2/JERnbSFfuH1rRoFhMFSoi8KqggPDsAeQITg5P6
1qnAhTsrJEEejnAqylizbahF7qBk6YnG13YCjqighqJmcRDD30DIRk3hEYyFil/a
3Twu5QH5b+klCTdHRDF60vPnQATP9XrzR64KWfeWfLc/4xSNhGJdP4+UBIbbTCnV
ryi87IVUEPPIoY/eWy4HwU40wDDssk8UHt4HsafrvzMFiyJBZVar9HoiQI8dT46u
oz5bTnPaMDGwhejjNHjFb2agKjEZgSJ7TG2tZ6nxfvyMjowhmSeaLaBrhxVGJ2at
2DtWWpo2d7ay5DkwFg61
=OmjC
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Feb_2014_15_54_12_+1100_Itl8SJ67dqJbfMsM--
