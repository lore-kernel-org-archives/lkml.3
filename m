Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3CAGmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:42:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34010 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab3CAGml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:42:41 -0500
Date: Fri, 1 Mar 2013 14:39:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, ian@slimlogic.co.uk, lrg@ti.com
Subject: Re: [PATCH] regulator: palmas: use correct device node for DT parsing
Message-ID: <20130301063915.GD25302@opensource.wolfsonmicro.com>
References: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com>
 <512E16EE.2050201@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <512E16EE.2050201@slimlogic.co.uk>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 27, 2013 at 02:23:42PM +0000, Graeme Gregory wrote:
> On 27/02/13 14:10, Laxman Dewangan wrote:

> > When device is registered through the DT then regulators node
> > exist in the parent device node of regulator driver. Hence passing
> > parent device node for parsing DT in place of self-device node
> > which is typically NULL.

> > -	struct device_node *node = pdev->dev.of_node;
> > +	struct device_node *node = pdev->dev.parent->of_node;

> This is not correct, nor is the reasoning.

> I suspect your previous patch broke DT probing so your not getting nodes
> filled in.

So, the reason that this pattern has generally been followed is so that
the regulator core can do the equivalent of regulator_get(dev, supply)
to find the supplies.  Using the parent device there is particularly
important in non-DT systems so that we can map the child regulator
supply in by using the dev_name() of the parent rather than the MFD
internal subdevice name but for pure DT systems where it's all just
direct links it's less of an issue.

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMEzgAAoJELSic+t+oim9yP0P/0Mtnp2U1hSabw5NbacfVy1q
d6yEfgCVSo3UlE0GGlndBgHuziuhdSP9y+O/7d8+yxbNCkwDsiNqL7+rbUsoecxD
4ImbpPpy1N04gII89aiod8b0aqkPebmLAf1rW0AsyjOZwqEx2tLCr9hr9jhXGUvt
WWiNKW6kjRCjhfNE76R20HaGAgdTUgtf7s6vH7H36RH+i4pWNvAvNcx02vi4tZOs
fq85sQr/AB9IJSxVcj6oqXE+VDt5uDjtqnIDNbA3UI43t5TGpK50+dlM4Gw6ar4E
bRzHmRUshYGaESggVHxhwx7YBZS1HQAy4jkf22Z4yXZlAKSu4ICJEGxf8ziQf/4z
8uZABrBdZ7E7KA1seYmrnpu1GiHHa/lhRAN0qur4kTzGEYJG13YOqY5WfpeI4hUK
ouyF1volu2paBpbpE/KTig5xGTTiQZkJhRpVgYsNEK/d0wFFw7TnhNs4ghY3Hln6
vKoFMutIryEy/nyXPXZjkpkOH0JkRHtCR2kxs98KWWKx2f9svu8bFb58vmH8KZg6
24DbmIEREKsB2KrxeFYHNGbaQPbAPuLMXCgR+MM7O0VDpfRKhhTfdCzQTCSEq7nT
pt79HJpWZvvoMYcaA9Tq4UDBZCHEfVxEpdaBhIO8xnyhvBM9OAG8G+02GVeSTMiK
bafq5SCuK0yJUOfNPofX
=TIKZ
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
