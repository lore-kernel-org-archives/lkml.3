Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbbA1Unz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:43:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbbA1Unx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:43:53 -0500
Date: Wed, 28 Jan 2015 08:08:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] drivers: usb: dwc2: remove 'force' parameter from
 kill_all_requests()
Message-ID: <20150128140832.GE5608@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
 <1420450295-25818-3-git-send-email-r.baldyga@samsung.com>
 <20150127154232.GE14623@saruman.tx.rr.com>
 <54C88D46.5080803@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <54C88D46.5080803@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 08:18:30AM +0100, Robert Baldyga wrote:
> On 01/27/2015 04:42 PM, Felipe Balbi wrote:
> > On Mon, Jan 05, 2015 at 10:31:35AM +0100, Robert Baldyga wrote:
> >> This patch fixes in simpler way the bug described in [1] and [2]. It
> >> looks like DWC2 is the only UDC driver that doesn't force usb requests
> >> to complete in ep_disable() function. This causes described problem,
> >> because we have no guarantee that all requests will be completed before
> >> unbind of usb function.
> >>
> >> To fix this problem we force all requests of disabled endpoint to comp=
lete.
> >> Also currently running request is not handled. This allowed to simplify
> >> code of kill_all_requests() function, because 'force' parameter is alw=
ays
> >> set to true, so we don't need it anymore.
> >>
> >> In s3c_hsotg_rx_data() we change function used to print message when a=
ctive
> >> request is NULL from dev_warn() to dev_dbg(), because such situation is
> >> harmless for driver and now it can take place during normal endpoint
> >> disabling.
> >>
> >> [1] https://lkml.org/lkml/2014/12/9/283
> >> [2] https://lkml.org/lkml/2014/12/12/360
> >>
> >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >=20
> > this fails to apply:
> >=20
> > checking file drivers/usb/dwc2/gadget.c
> > Hunk #1 succeeded at 2602 (offset 35 lines).
> > Hunk #2 FAILED at 2588.
> > Hunk #3 succeeded at 2645 (offset 36 lines).
> > Hunk #4 FAILED at 2924.
> > 2 out of 4 hunks FAILED
> >=20
>=20
> Isn't this patch already in linux-next? I see it's also in your 'next'
> branch.

if it's there, good.

--=20
balbi

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyO1gAAoJEIaOsuA1yqREjXgP/jU1cK0WlEJiADerlAgxOsqb
cz5kvcD0GFTZezDDZZoxmzAOs+MhlNsfS8nH9F4UClVBVFMRb3Z82YHlFpuMBSfj
4TiAgw59aP8ENQDcwNIbDXoSFX+wA5QRe4Os+IKZQrPg6yuPvAeJjMkSKil4I5KV
LtPIOlihh5fp3zaPfft/j869OZNHIt58LQRO0ZYGq+S+mbihj0HEKsXtD1ptlYM2
uy0Wljc5wR92oLLFBBUDyOuYsax2DqWeHsedQZUj4ELDSkBOTcZHJVqQ0Iy4HOcp
TzAPBSVoi5OKab7Mxp7XGhf2JX1GFiYC5TZTZJnEe0F/LhhDga9eXgKHKSkd5aOy
MDi6GBGp5OJzJc5uMYimAh9P+aO0NOc8J2JW/pC9jTCMYSd+GG6N2OOoqzVYvOpL
4dmWh3aqq+xYMxDpAvOSvdn5pSPJCUnKjZKGj5NJOZksaumRFg5ZqdDETjd1P1Y/
t6dW3xLzZpvQG50cIhbud/Er3ZdHJ1XR1T30oYxadx+N5j+E2xMujPl99UnZh224
9hgEUvWlQJPyBfH+RQkCML3952TvVhYhC7uaU1yCzQqwAYaLbc97TvF38bWh/dQr
z79BNQiCIC9XPgLcLTfS7vcE63tq1R5PaTOsWVyfKB/H3UYx6WJIPLvuff5YP87m
O87qQiNhfvlvhaU9rYxb
=0gif
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
