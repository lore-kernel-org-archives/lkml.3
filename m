Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbbAHRQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:16:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51289 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAHRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:16:24 -0500
Date: Thu, 8 Jan 2015 11:15:23 -0600
From: Felipe Balbi <balbi@ti.com>
To: Songjun Wu <songjun.wu@atmel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: gadget: udc: atmel: fix possible oops when
 unloading module
Message-ID: <20150108171523.GL31926@saruman>
Reply-To: <balbi@ti.com>
References: <1419932967-2694-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umrsQkkrw7viUWFs"
Content-Disposition: inline
In-Reply-To: <1419932967-2694-1-git-send-email-songjun.wu@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--umrsQkkrw7viUWFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 30, 2014 at 05:49:27PM +0800, Songjun Wu wrote:
> Executing the 'insmod g_hid.ko', then executing the
> 'rmmod g_hid.ko', the NULL pointer oops will be triggered.
>=20
> When unloading the module 'g_hid.ko', the urb request will be
> dequeued and the completion routine will be excuted. If no urb
> packet, the urb request will not be added to the endpoint queue
> and the completion routine pointer in urb request is NULL.
> Accessing to the NULL function pointer will cause the oops issue.
> Add the code to check the urb request is in the endpoint queue
> or not.If the urb request is not in the endpoint queue, a negative
> error code will be returned.
>=20
> This bug was introduced since the file 'atmel_usba_udc.c' was
> initialized. Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
> Cc: stable@vger.kernel.org # always been there...

this is not the way you write this. There are tons of examples in the
very git tree you're using of how to do this. Just run:

$ git log --grep "Fixes:"

Also have a read at Documentation/SubmittingPatches and search for
"Fixes" in that file. You might also want to look at
Documentation/stable-kernel-rules.txt to figure out how to properly Cc
stable.

--=20
balbi

--umrsQkkrw7viUWFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrrsrAAoJEIaOsuA1yqREt0UP/2tsi5J+6hSeQYsNkqh54b/t
wt9bkuMCXrF107tivInvpXGkZXmhypWkVHCZZI8fM4NYhgkxFR6/fk6L2ZpyuOyq
feOfpMo5b2G3nF6tip6ZbdXaInh3zsFji7P3k94GaOp148DSqfVRxF1VOrnoh7f/
tkrxvR65qsRL6oo9sxRQI0rOLpTdj1mFcU+Iz2XQQzIiWXGKAMtUN6mAE5DvpCze
GXEI8K5kDVs37WQC45UxWGE2olAJgtg8aPBWcZdSLKy8zTAtPPv+GsInhZOLkOCL
Qbq7qw2/DPw7oaT7dkEKytR3W9A03q/pJfTNspW8hSrAFvcUNE2c8ad2uGPGxcQ0
QD4EfW6wi+mMrmVcfTzmhq50HwL3kouUl0TgUsSu8IcsYQOuy34B5aCPrIi36d44
xSzBRgIvI58MOH1yFYzCp1jSReid149lYuX9eeJMOX6WJ7qczhakCGaWqSBF1rh6
4qZnsoohUZuee+mELNjXlua5tAD1ztbcWPegeW+ksVpXcXQ3+b6qEgOfIrQmSjO3
A69YKNGaFA4lD/ymWEGAK6RnrXeWsqZhchCl2HvzygR9SmTqfpqmcGSCV1kVGphS
BTnf+IlCjIz2Q/eo+fi2PyQ0RfH1RNN7Xv0qxxkUyxBwLyaDoXcn+CgT9F+dx5Ow
lKrbCadRMdyakVOM9oZ9
=6JWK
-----END PGP SIGNATURE-----

--umrsQkkrw7viUWFs--
