Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3IQP7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:59:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33974 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3IQP7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:59:42 -0400
Date: Tue, 17 Sep 2013 10:58:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 5/6] USB: gadget: s3c-hsotg: fix dedicated fifos handling
Message-ID: <20130917155841.GP15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
 <1378995532-32142-6-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brdEIFGMNIjz5YJG"
Content-Disposition: inline
In-Reply-To: <1378995532-32142-6-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--brdEIFGMNIjz5YJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 04:18:51PM +0200, Robert Baldyga wrote:
> This patch adds few fixes:
> - In s3c_hsotg_write_fifo function PTxFEmp/NPTxFEmp interrupts are enabled
>   only in shared-fifo mode. In dedicated-fifo mode they should not be used
>   (when enabled then cause interrupt storm).
> - When s3c_hsotg_trytx is called for ep without enqueued request, interru=
pts
>   for this ep are disabled, to prevent interrupt flooding. Interrupts are
>   enabled when new request for this ep is starting.
> - In s3c_hsotg_core_init enabled INTknTXFEmpMsk, becouse without this mask
>   TxFIFOEmpty interrupt does not occur.
> - In OEPInt/IEPInt interrupts handling added bitwise and of DAINT and
>   DAINTMSK, because we should handle masked interrupts only.

each fix in its own patch please.

--=20
balbi

--brdEIFGMNIjz5YJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHwxAAoJEIaOsuA1yqRE3s0P/jrBfBxvYVPQkFDMfk5zTMxK
uQWeoe6AuukfH94ua6BXJhqsIGTS97hS4ZAd9Dya6JZCNtZsp6pCxaAF2qaVnqjV
6zcyQ/PJvopaVir1y79B8cOkd6XnHtIpoCyVWL8uDuHjgSVDaROJ8GCczQhR5lwp
M4Vb5GDArvWWfrD8VGCsC+tkoxafJiltdcMd4yiY9eGPf92nre6T+f7NtEQfCCP4
kFg5nC1rV5oNfhfMYkhWsUBctSIEcHCDDz+GvXmh6xI/DMjCIw9Txr4aQonvH0Gb
4G38Ok2XovRFePuCaspwiNZYd0+k30oV4fzmlqve2iuDgYaMFJCW5ad8STJT5cSi
3PIiSZrNhYl4h9onCXbak3bshyN49lBwY2LCZESloBfsZs5Uliso9v7A2y05MdyY
WkG/KF3cKDu/+qrZoKk0ZWZxlLchiUO/s0SYFZQxr9sHkUw2TyQFgSi80cm4UKm2
aBkgzDNu1ouUZyTn5hEqMbzzCdypJ9cGluAXgMtOUg1Zhp5+bkRABYL0DIZU7akX
783gwzxaI4+KDEiDPmiSKS4mCZDRn3ePwjahaacwnj5/kwSsDTD5MFBJtq1F+EP9
8iyzOdvrEJLQBYtg4lh5gzf5qgqR6Gr3TGNDYWyL/UDtBpuxIpPAI3M44jqZSVjz
vqvkFhSefyc4nU81o7ee
=jOgN
-----END PGP SIGNATURE-----

--brdEIFGMNIjz5YJG--
