Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaDYPMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:12:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56907 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaDYPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:12:45 -0400
Date: Fri, 25 Apr 2014 10:12:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 1/9] extcon: Add extcon_dev_allocate/free() to control
 the memory of extcon device
Message-ID: <20140425151222.GE29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:16AM +0900, Chanwoo Choi wrote:
> This patch add APIs to control the extcon device on extcon provider drive=
r.
> The extcon_dev_allocate() allocates the memory of extcon device and initi=
alizes
> supported cables. And then extcon_dev_free() decrement the reference of t=
he
> device of extcon device and free the memory of the extcon device. This AP=
Is
> must need to implement devm_extcon_dev_allocate()/free() APIs.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

except for the one comment below, you can add:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> @@ -267,6 +273,13 @@ static inline int devm_extcon_dev_register(struct de=
vice *dev,
>  static inline void devm_extcon_dev_unregister(struct device *dev,
>  					      struct extcon_dev *edev) { }
> =20
> +static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
> +{
> +	return ERR_PTR(-ENOMEM);

so this is executed when extcon isn't enabled right ? -ENOMEM is kind of
lying to your user. You're telling the user that you don't have memory
when in reality you didn't implement this function. -ENOSYS looks like a
better choice

--=20
balbi

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWntWAAoJEIaOsuA1yqREla4QAJR7jcu+V0RDiLGfAZemPRm2
26oiwrjbxPxhQ7hXxcUBSi687G4fI3qC7b68YCFr2aVIvO1oR1RqTLOZtRBDb6so
trJIvBGk1JMlnNrMIHvswz3Mq6FLO4A0ZQxn3nUfyzvMZwnLO9H8RZ9bGGNRpc2y
i6o+2q+LBQwyKKTbk04QU5KOPHlKjM8w6goZWQoMrVT//A7LtzzdtgSzO7FvzkjL
tMZZPboQoAT/DiBRwmGxzeKBjaS5ceyD0UwsjsAkNPLS/EsREqAwQN7O1GW+mPrP
P6C9SkhImB6ywGqYH9JG2yPi7b1bxEPixzQbQUit7cG99c+Hq/a70oHnhz0IHMoE
DUXS1rrhiys80rPfFW4ivFbfiu4CbtJf7HuEoSbTrH5Z74IwThLkqKXc7YoH2ISZ
haY0JljiDwNNUxuA2GVZG8T3oj5bUDRdZfVlr5jj5bOTHG+x5Lb1UV8UAZXRL8an
gizCLY1CKi6MF5FWIZxMaPt+tWt13mHfa6JFLcrsFrZiQqVOoxpfxvz57s37sPkX
+QpGvhY4lKsXIGyQ27n6k3ZMlP0G2ytKMeKh6VXEPdiV1pyV0jLQBCHPMKiE84G9
0t8JBhMUcht8NNpJ0Zhe0ErNd+A2LD8hPdRPPsDTOPLhCFfJ097O7vzqGCXZd0zw
JHPNkdFBIW0mJLuTm7Te
=fjeY
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
