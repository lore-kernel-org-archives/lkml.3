Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaANOGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:06:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37666 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANOGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:06:09 -0500
Date: Tue, 14 Jan 2014 08:04:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Suman Anna <s-anna@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 6/7] hwspinlock/omap: enable module before reading
 SYSSTATUS register
Message-ID: <20140114140440.GA15785@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-7-git-send-email-s-anna@ti.com>
 <20140114131052.GA10818@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20140114131052.GA10818@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Tue, Jan 14, 2014 at 07:10:52AM -0600, Felipe Balbi wrote:
> > diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/=
omap_hwspinlock.c
> > index 9f56fb2..194886e 100644
> > --- a/drivers/hwspinlock/omap_hwspinlock.c
> > +++ b/drivers/hwspinlock/omap_hwspinlock.c
> > @@ -101,10 +101,23 @@ static int omap_hwspinlock_probe(struct platform_=
device *pdev)
> >  	if (!io_base)
> >  		return -ENOMEM;
> > =20
> > +	/*
> > +	 * make sure the module is enabled and clocked before reading
> > +	 * the module SYSSTATUS register
> > +	 */
> > +	pm_runtime_enable(&pdev->dev);
> > +	pm_runtime_get_sync(&pdev->dev);

another thing, you need to check return of pm_runtime_get_sync()

--=20
balbi

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS1UP3AAoJEIaOsuA1yqRElJUP/1F/oueJnqaGY9iM1/c5pe7y
/nEliOv45s/+Xm+j8G0oau9eN002nbN83btf5t8w89Tbkntp9hR8kuKh1YdgX3NO
7lgHT1EE4HkyQSsI8+XnBEhZVnIehnbBaExeFu7UIxY/BtA84aZ4qhVQuA2AfTMG
HlxCCGv+pwIW5xrwiS2WkByNXlD9L72YHmqZHyzl/B4HbYjbcvkfwh1/LN1TCD21
Kat9RVwAoUPgp7xD61JIO0ig6I+O73HRzW2Xjbj89j9gs1hVLTBEKNElxgg7LhcH
vsPQhynShlZwNQN2iAQP9MPXVIVpb5ZI2RpWjJS26ai8B2G38sV7q95ILVrkgLTK
T6wAgnEMjTysE67r544lvzi9QEGaAGYPOnl2M8EBnqVlxLuNh2POwBeTpGJJrQUh
s5TFG3XD0zj6OVcpusQwrrnF4XUk2FLXxQePkmaPADJTMBnqD5g/QZnl9VfVEj7B
0ICbmYhzODgKhdQtkIJFdstdwPSL0BmkHKkCLxc68Za34WVYFGbLeVYR/XuUt5U8
AJKcA7MyC+vg/jKUL13qaYm7KwdmkZRkLtBT/KG90A2jEwygckrWn/pDNT66RjhS
ukVrLw3TQEd+6Nnp+MRHV+ANJhHMzxtlF3Z97N3seckON7Wrt4SqaOsnwqII+A10
xMGT+/pN+qjO/X93kwEC
=tdmP
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
