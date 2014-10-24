Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaJXTTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:19:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34949 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaJXTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:19:23 -0400
Date: Fri, 24 Oct 2014 14:16:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141024191627.GA11455@saruman>
Reply-To: <balbi@ti.com>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1414177592-14547-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> Remove redundant local_irq_disable() at machine halt and restart.
>=20
> Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
> smp_send_stop()") interrupts are disabled before stopping secondary
> CPUs.

Assuming this is correct, you should have:

Fixes: 44424c3 (ARM: 7803/1: Fix deadlock scenario with smp_send_stop())
Cc: <stable@vger.kernel.org> # v3.12+

> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  arch/arm/kernel/process.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index a35f6ebbd2c2..5663ab57cf07 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -195,7 +195,6 @@ void machine_halt(void)
>  	local_irq_disable();
>  	smp_send_stop();
> =20
> -	local_irq_disable();
>  	while (1);
>  }
> =20
> @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
> =20
>  	/* Whoops - the platform was unable to reboot. Tell the user! */
>  	printk("Reboot failed -- System halted\n");
> -	local_irq_disable();

=2E.. but wouldn't this reintroduce the the buck which that commit fixed ?

--=20
balbi

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSqWLAAoJEIaOsuA1yqRE9Y4QAI7skK5cGhn133t9K2GAmXIg
Ul+rOaMw6bjDCgjgG6nUPqfZnRmc8ciYQLE8rZZ4FnN/B+SoxYxVQvsE4uTDIW4A
wo2riYd/017c8vP/BdrbbylHyjsXPkE4uwItYrNRFFEU5556N43WwFzvZhSKkTg5
OK36mg18xe/8PYNBZzQd1GJg9JfFG2kzSqjUXTbGXqS5/jGr0KevHcNr2csPVXOE
5mhy+bshW/suxbCNRkV7oyAZ/U9kDqv6O+SYlqq717y1bA+6CFmwbWDW7+A/25I+
sPY1SY6bMNddpWLmQSSR3kBZ6v8eoQZ4l2JNtlgIxRPkMHTotlKFb0zw3dTKqB0a
UGXIGxd82tZP0Ylhsl8ZbGcq0Wz4IPVLKOkPbczqr/6TzuSEisIAQ5NjWlEpkGgQ
Hwcv4x7sMOFY5MdKLWsCxVNgGNZ86sL2lhfsg8uXhv4VBXyPKr6L3Se2R+hzr03R
LNAShsCA5v9ZfB2N/+/XheOV0ZSHZ8lM4CFRlytKQTTWJYlHByCQoNz8210GfHo3
AmrwLZYHHPK7ujD8FfbRwjvMicz7NRktTaV1pxDi6dFal0QVujbfIIiYuAgfLyVX
94uk7gb1+4ls1oUMAwlEgu/vQ5xoIXxZWCI2PCDaZciWHskTxssal9HoclPPUEaV
h+Z8e7rPI8cV7VLsVx6c
=6ZMd
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
