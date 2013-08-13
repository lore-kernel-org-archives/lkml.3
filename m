Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3HMH6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:58:36 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43319 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HMH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:58:34 -0400
Date: Tue, 13 Aug 2013 09:58:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] PCI: mvebu: move clock enable before register access
Message-ID: <20130813075830.GC9316@ulmo>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <1376333215-12885-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 08:46:47PM +0200, Sebastian Hesselbarth wrote:
[...]
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
[...]
> @@ -897,6 +897,16 @@ static int __init mvebu_pcie_probe(struct platform_d=
evice *pdev)
>  			continue;
>  		}
> =20
> +		port->clk =3D of_clk_get_by_name(child, NULL);
> +		if (IS_ERR(port->clk)) {
> +			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
> +			       port->port, port->lane);
> +			iounmap(port->base);
> +			port->haslink =3D 0;
> +			continue;
> +		}
> +		clk_prepare_enable(port->clk);

I see that this was already wrong previously, but since you're changing
the line anyway you should probably also check for failure of the
clk_prepare_enable() call and error out if it can't be prepare/enabled.

Thierry

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCecmAAoJEN0jrNd/PrOhLgIP/iuTZjOmdnHZG3MU4B/B96ti
6MuJ3ANB+0R2f29ifhboYPHnaxjDiSYmpNDXnSm9Yn+4RVNJYaEm76xUaEFgHj78
fLo1nVNClWEp8CtJNKWAIrlCnR9S/rH7+Gi6qyQ+XVRu7FhYOy611OiGStnKY3KY
aLLH3ZWzFxk5E/+4SHC+NkzVEL54YaNDtxlf8A3SiNR2Lr62GvJIKR/OtF9io1lU
p6jbyy/xzCSthAan2zNdts0DzLV0I63+FIgLBTJFVzLrZZZkODt8oPryuBbsBF9d
bas2zCrQ0IbKqDjCwY7f8MnixI4LHXXcWha3VKfCglyNpM52YO6+pMuN5wj1QGYJ
Ym6XfvCyDsaEiXPTmiWNzhmNQ30cjBq/PyErN6AyPV8McDz3pYZMtYc7Ee2fPQIe
wiBeiPrHejDcDg/WowwCW76y847dDkNBpI5XUCC/mFEPGwrWt4K/4cz2Mg32p7SA
dDUyfupBpSeUtgykEjhg7hof9yjvz9KJWyqzdwAXV84s9gDB4EeoWOhsvY1Fd6O9
YzdlB4Pu9C57Bn1XOBw4OB0ma1qqHRu2Hn2G8eQCeqq1KbTni9hgEDVvDD2QDIw3
jLA0DJRaNABkG0yMBJKESydUc+oCTm1q7bq93Z3ZWbnb4Nuls5vOO+dlTcMk/Bhv
JHVgoxV2mHKxBEi+vpeW
=vX32
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
