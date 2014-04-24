Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbaDXOrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:47:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43193 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbaDXOri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:47:38 -0400
Date: Thu, 24 Apr 2014 09:47:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv3 9/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140424144717.GI26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-10-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PMULwz+zIGJzpDN9"
Content-Disposition: inline
In-Reply-To: <1398342897-23670-10-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PMULwz+zIGJzpDN9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:34:57PM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Tested-by: Felipe Balbi <balbi@ti.com>

*BUT* you need to fix NULL vs ERR_PTR return in your code. The way this
is, we can easily dereference an ERR_PTR because the code doesn't test
for it. I suggest always returning valid pointer or ERR_PTR and avoid
returning NULL at all.

--=20
balbi

--PMULwz+zIGJzpDN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSP1AAoJEIaOsuA1yqREEh0P/iU6OC0q9XwjDmwupJPrf2As
5owMg5SqFjpSqtFcNKWMXJALWGniBJ6UF/KAb2AIRmY7RrndK5AUDdbgSS9Miiwb
qLzpkeUD6xnsv7SxeZZ1DFXEzyNNQzaECG1W2oZYcM1JiODtQAKs2eWF9Wa72CJG
VHNelkxPjjNfqbKMJhzA15fcUPgjEUWaC9KLQ0e6zPE1gI/yPlpPiqEBwzwP5LhL
hikDYe5d+Lsz7hHl99d4vOqPNvmgFeeXVh53Vq+9vIspWqaCsqh386AACKCZZ859
ANTOdc3KDrdDZjolAmpS6pdVbgn0GV3e2U3uof33G4PeUvKREJm9t/Zvmv7/3hEv
NE2abRRzmAEX9jusZuuSg8zwnjbjwhKZwW9oiszypudz/p5nTkQCHw99j79V4Vsu
1LRDWhc27C6fwEQm8hF6c8hPWgZRBM6kwF8yL3T4HwgLvFet/s/YJNmhb+/5BjlG
w6NETzpHbjSiru3pRzst6JG9cXZ096Ejb64EtqgDfdZHEnBoGHGx/Z+yFd/htkVF
f/zT63+7m9TEFcL0bEhk23eB750Nf7AaLpqGwsMdgmRB4VklAI4pultegiMinpiv
60UoNms7SQORZHuIsu3mo6jVJWxAjHCSHtlIIOXMmzRUy09RtukXUlHrJbE06yib
j7qToWJZr6AVsgSHKqDz
=8HnA
-----END PGP SIGNATURE-----

--PMULwz+zIGJzpDN9--
