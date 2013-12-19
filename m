Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3LSOt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:49:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46252 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3LSOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:49:28 -0500
Date: Thu, 19 Dec 2013 08:48:48 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Du, ChangbinX" <changbinx.du@intel.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: should use u16 type variable to store
 MaxPower
Message-ID: <20131219144848.GF3985@saruman.home>
Reply-To: <balbi@ti.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01A2B920@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fwqqG+mf3f7vyBCB"
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A2B920@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fwqqG+mf3f7vyBCB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 11:47:42AM +0000, Du, ChangbinX wrote:
> From 7e827a0d300e084f74c65122baa5e3193f9a7f18 Mon Sep 17 00:00:00 2001
> From: "Du, Changbin" <changbinx.du@intel.com>
> Date: Mon, 16 Dec 2013 20:32:13 +0800
> Subject: [PATCH] usb/gadget: should use u16 type variable to store MaxPow=
er
>=20
> The MaxPower field is of u16 type. So using u8 type variable can break

Alright I see we need some cleanups around that area in the gadget
framework.

Descriptor is always a u8, no question about it. But
usb_gadget_vbus_draw() receives a u32 as argument, while
struct usb_configuration defines it as u16.

I'll take this patch anyway, as it solves a real issue. Thanks

--=20
balbi

--fwqqG+mf3f7vyBCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSswdQAAoJEIaOsuA1yqREAXoP/jOoxUrIhRVWuqJ1LKohTXXh
A0uKm5HFwNn9KP1LsY/oNH+qjN8XoBl1z7XqiiTiEX1GGtARSbfGQ9Hq0H04iYFH
Rn3QFD6AA2Vo7Eok5cSGQFK7tn/e3tqtQKYc2JINN6UmhCX4VtxPn+ysvkoV144R
qDRE4nJXkFEOnMkjVjQnoiiOa4NwD+iH2/wAY6wAf/xHNavZ0ksOmfot5UVa08tj
mSlbeeDglctieeo5gF209BW528C4mysDt9QP0dgHr/0wBYaiSwTDsl2jpprixbyX
QnFsu9r7CSMmHDkbxEMEZns5d9Rj/RU08Cu5ZzMXxPtlNmW/759XCDFcAQ8PJH4F
i23cJtZTaZbpuPTV2C1C/5kMvYpVyKYWnLWxJl6ma6wdzspNGAyukCX/4NBb8Gnj
qAThPykZXa/iBOAl6GoFjRq1IWLh4woW8zxhlZr/RkMY1t341ImmgD6YVdvoQo+O
H9tmQLRGCYNsC7jUixUHDROEX+gcysY8udC8CkgtQO3/QhXsvEMAvqK6lChJ+8SW
eX8KVZqjeynKqjzvv5QzDd2kzIOtgVx5qo1MzxkhVo7S9sOk0aznqTB18TfcI+pe
n55VMB8gY5m6R7ajtIhJhuBP7/t1axecZRpbDWeWwGeLEnBx3WhqDCRPcxhwxPnk
e3h5pB6cIhqQZb5K6xox
=VTnz
-----END PGP SIGNATURE-----

--fwqqG+mf3f7vyBCB--
