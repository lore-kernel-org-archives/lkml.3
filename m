Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3K0O71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:59:27 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:52501 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3K0O7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:59:25 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: hci_h4p from linux-n900 branch: fix with new bluetooth for 3.13-rc1
Date: Wed, 27 Nov 2013 15:59:21 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
In-Reply-To: <20131127125149.GA9389@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1465865.uQsI5gFffN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311271559.21855@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1465865.uQsI5gFffN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi, I already have this patch prepared for 3.13.

On Wednesday 27 November 2013 13:51:50 Pavel Machek wrote:
> commit d18adf907651766c97eedae993f14c6e042914a6
> Author: Pavel <pavel@ucw.cz>
> Date:   Wed Nov 27 13:43:40 2013 +0100
>=20
> Fix compilation of hci_h4p after bluetooth core changes. Only
> compile tested.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> --
>=20
> When you update to 3.13-rc1, you'll likely need this one.
>=20
> (And good news is that it boots with that kernel, and video
> seems to work.)
>=20
> index 7ed9d4e..dac3875 100644
> --- a/drivers/bluetooth/hci_h4p/core.c
> +++ b/drivers/bluetooth/hci_h4p/core.c
> @@ -405,7 +405,7 @@ static inline void
> hci_h4p_recv_frame(struct hci_h4p_info *info, }
>  		hci_h4p_parse_fw_event(info, skb);
>  	} else {
> -		hci_recv_frame(skb);
> +		hci_recv_frame(info->hdev, skb);
>  		NBT_DBG("Frame sent to upper layer\n");
>  	}
>  }
> @@ -789,10 +789,9 @@ static int hci_h4p_hci_close(struct
> hci_dev *hdev) return 0;
>  }
>=20
> -static int hci_h4p_hci_send_frame(struct sk_buff *skb)
> +static int hci_h4p_hci_send_frame(struct hci_dev *hdev,
> struct sk_buff *skb) {
>  	struct hci_h4p_info *info;
> -	struct hci_dev *hdev =3D (struct hci_dev *)skb->dev;
>  	int err =3D 0;
>  	unsigned long flags;
>=20
> @@ -841,12 +840,6 @@ static int hci_h4p_hci_send_frame(struct
> sk_buff *skb) return 0;
>  }
>=20
> -static int hci_h4p_hci_ioctl(struct hci_dev *hdev, unsigned
> int cmd, -			     unsigned long arg)
> -{
> -	return -ENOIOCTLCMD;
> -}
> -
>  static int hci_h4p_register_hdev(struct hci_h4p_info *info)
>  {
>  	struct hci_dev *hdev;
> @@ -867,7 +860,6 @@ static int hci_h4p_register_hdev(struct
> hci_h4p_info *info) hdev->close =3D hci_h4p_hci_close;
>  	hdev->flush =3D hci_h4p_hci_flush;
>  	hdev->send =3D hci_h4p_hci_send_frame;
> -	hdev->ioctl =3D hci_h4p_hci_ioctl;
>  	set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
>=20
>  	SET_HCIDEV_DEV(hdev, info->dev);
> diff --git a/drivers/bluetooth/hci_h4p/fw-csr.c
> b/drivers/bluetooth/hci_h4p/fw-csr.c index af880d9..020fa52
> 100644
> --- a/drivers/bluetooth/hci_h4p/fw-csr.c
> +++ b/drivers/bluetooth/hci_h4p/fw-csr.c
> @@ -31,7 +31,7 @@ void hci_h4p_bc4_parse_fw_event(struct
> hci_h4p_info *info, struct sk_buff *skb) {
>  	/* Check if this is fw packet */
>  	if (skb->data[0] !=3D 0xff) {
> -		hci_recv_frame(skb);
> +		hci_recv_frame(info->hdev, skb);
>  		return;
>  	}

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1465865.uQsI5gFffN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKWCMkACgkQi/DJPQPkQ1Ir6QCeOGvbK8rl48yo1YLM67h1AGvh
NEUAn1V0nlc0tw2dBJCbpU9C8PIJvlh8
=oOfl
-----END PGP SIGNATURE-----

--nextPart1465865.uQsI5gFffN--
