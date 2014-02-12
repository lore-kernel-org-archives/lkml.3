Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBLIRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:17:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50298 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaBLIRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:17:06 -0500
Message-ID: <52FB2DFD.8080408@ti.com>
Date: Wed, 12 Feb 2014 10:17:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] video: Use fb_sys_write rather than open-coding in
 drivers
References: <523BF40B.1090002@gmail.com> <52FA2E57.3010300@ti.com> <52FA7509.1060704@gmail.com> <52FB1AB0.6090601@ti.com> <52FB005E.1000207@gmail.com>
In-Reply-To: <52FB005E.1000207@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="q4Fa2E4g585lCTfIN04iWTOsGhNm8JgPN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--q4Fa2E4g585lCTfIN04iWTOsGhNm8JgPN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/02/14 07:02, Ryan Mallon wrote:

> Well, the alternative is to supply an fb_write() implementation for eac=
h
> driver that calls fb_sys_write(), and then updates the display. The
> fb_sync() additions can be removed. That would cut down the boiler-plat=
e
> code, and should keep the behaviour the same.
>=20
> If you don't think it is worth the effort, then the patch can just be
> dropped.

I'd be very cautious about doing cleanups on drivers that you cannot
test. Small innocent looking changes can break them.

For example, your patch sets info->screen_size, which is not set
currently. Does the fbdev framework use screen_size somewhere
differently than smem_len? I don't know, but that could lead to small
difference in operation. However, in this case, fb_sys_write() actually
uses smem_len if screen_size is 0, so that change is not even needed.

ssd1307fb_write() looks a bit different than fb_sys_write. I don't know
if the differences could cause issues. The other ones look copy-pasted
from fb_sys_write (but I didn't look at them carefully), so perhaps
those could be cleaned up safely.

 Tomi



--q4Fa2E4g585lCTfIN04iWTOsGhNm8JgPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+y39AAoJEPo9qoy8lh71S2UP/2q6zyoIPmV8rd8YARCBZeDC
gH+bxsMC7jjgKZbaQMSR08gJU2ZKPj/N9Y/fUJ+2Q4ghZdjjyrmPzdro63MU+pb1
IMc0mVm+nJu92diq+zxl+WCuQa7qJW2Fzp5p2MOfxEv0iq/sn+RxRrbHUSr6O3m2
Appo5Yzb2bE5E0+lTCHiaTlk4K4SnUfRZE7pRxBVJd7ze4VZEm//EcGQBchOO0qj
Up1Z4vg0TeJSoNZO07V/0uK32CzdiDpuaya3e6M68/z6rybUo2Tx4xUBjnYHngHh
5EA+LNYm8HOXnWN60LEkY/qycud3VEaP+kDWKJI7KRpcrXffPw/nQmGbNaU17uUu
zyo0TsvRGaWW/lmJuQ7I2+snfEbsPDfY3xG42fGyBvoCcLDBrCSFRqrkHYIEciS4
AwGuANRrlC/ouIEtKzQT1mdSttCCImsodbUvG5o0zza+iFX8s+12aOv6D4JlVMvU
zrqgReWW1qd3/Vh0ecSFMd1Fw0wRDa0NeDDXFRDZybh8kJTWBRrDbhcYnwkXhR8R
yQXOAbnfeNdWjhye8UgyF20bJTVrf143lnlu+KNiDe9atRERjvydEReSsN9Jhr2a
vXxI7s/sl46tfcg419M2eb4Tt7/SoY9u18T/GaC4AbpSfxAQmV/+Ga/aZdPczj2L
Dxb/CWCk57ETEU9XKlzY
=t2N5
-----END PGP SIGNATURE-----

--q4Fa2E4g585lCTfIN04iWTOsGhNm8JgPN--
