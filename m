Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaFRV4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:56:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64372 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFRV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:56:42 -0400
Date: Wed, 18 Jun 2014 23:56:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: linux@arm.linux.org.uk, bhelgaas@google.com, wangyijing@huawei.com,
        jason@lakedaemon.net, will.deacon@arm.com, swarren@nvidia.com,
        kthota@nvidia.com, sagar.tv@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: fix debug prints relevant to PCI devices
Message-ID: <20140618215637.GB26514@mithrandir>
References: <1403114868-17533-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1403114868-17533-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 11:37:48PM +0530, Vidya Sagar wrote:
[...]
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..fcf2581 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>  {
>  	struct pci_dev *dev;
>  	u16 features =3D PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FA=
ST_BACK;
> +	bool has_pcie_dev =3D 0;

s/0/false/

> @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> =20
>  	/*
>  	 * Report what we did for this bus
> +	 * (only if the bus doesn't have even one PCIe device)

I find this hard to read. Perhaps "only if the bus doesn't have any PCIe
devices"?

>  	 */
> -	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> -		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> +	if (!has_pcie_dev)
> +		pr_info("PCI: bus%d: Fast back to back transfers %sabled\n",
> +			bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");

I think this now makes checkpatch complain about this last line being
longer than 80 characters. But looking at checkpatch output on the
current version of the file there are already some lines that exceed the
limit as well, so maybe this can be ignored?

Thierry

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTogsVAAoJEN0jrNd/PrOhAgMP/13nSDVvUdH4+X2QTuJgzYPe
PcuTtQHGb8WoeV6I5toBZf9eb0Bj002QLNS/EMAJYHNh477nDz8PttYKjdv5FW1Q
U9iHekbTS8jPw2JLOYvtBJBoaYGwnGiyq22ZCxkwKA3NqvdhgtTFVeDRNHNEXYeO
cN5Soy6pruORhoSN0rNzMxbT1nAzLjmixeSgIsTUdIRHXtpjpH9Ows61yv3Os6NL
JbUdebvyWwN0KDL8POqYEdlabdFeWSyd/WKzeO2ew05rcTeInVIub1fh0/igW4yp
hRdc1VqrMS4nmjcQZ9rnO4g9z8oYctEX9HXGZ41DbMeMdMDsBpJY3QMgPXGn5lGG
jclJfjY3lkn8W/OZDXebEjFR0Z+gAdjRx4qT/pIJTc7tcysrYTX7SmfYV+U6s2UR
qFW2qJX889ebtmGlhPmjPnjRD4L9cz5aL5Qyr6N8cXfSC7zoK0Rv3BtV3+lTJB0e
1XSXQ7fjHQGAHqzSqp36rBS49/Oienh0U30IFIfYlcUkZRep7mpYDbZ8Sox7FIa4
xu9OPDHvEUOY21JGsCcqInEzwp7K9U7GNtxXrdn+B5XYjvIR+mBXmTNJmQuxgZ97
/zYbqmjDR31G+MyGoBGnc0bYTsg/DUnNismxjSJUJDoZugMOjjwO1DcpDt3JNXYn
rSVMMXiluGEt4n+/nr2z
=9MYl
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
