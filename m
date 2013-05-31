Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3EaIOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:14:54 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:47158 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3EaIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:14:42 -0400
Message-ID: <51A85BEE.4000009@monstr.eu>
Date: Fri, 31 May 2013 10:14:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Export of_irq_count for using in modules
References: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com> <20130530201714.GE19834@game.jcrosoft.org>
In-Reply-To: <20130530201714.GE19834@game.jcrosoft.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WUSGCNSSCTXIHIQWTIFL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WUSGCNSSCTXIHIQWTIFL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jean-Christophe,

On 05/30/2013 10:17 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 15:49 Thu 30 May     , Michal Simek wrote:
>> Export of_irq_count for modules.
>=20
> can you explain why do you need to call of_irq_count

I need to count number of irq written in the DTS node.
It is not fixed size that's why I need to proper way how to
find it out.

I am using this loop.
	count =3D of_irq_count(pdev->dev.of_node);
	/* Alloc IRQ based on DTS to be sure that no other driver will use it */=

	while (count--) {
		tmp->irq =3D irq_of_parse_and_map(pdev->dev.of_node, count);
		dev_info(&pdev->dev, "%d: Alloc irq: %d\n", count, tmp->irq);
		ret =3D request_irq(tmp->irq, zynq_remoteproc_interrupt, 0,
					dev_name(&pdev->dev), &pdev->dev);
		if (ret) {
			...
		}
	}

But of course if you think that this is incorrect to export it
I can use what it is in of_irq_count body
368 int of_irq_count(struct device_node *dev)
369 {
370         int nr =3D 0;
371
372         while (of_irq_to_resource(dev, nr, NULL))
373                 nr++;
374
375         return nr;
376 }

Because of_irq_to_resource is exported for modules.
Or is there any better way how to loop over all interrupts in DT node?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WUSGCNSSCTXIHIQWTIFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGoW+4ACgkQykllyylKDCE+WQCfRaCIjTDTNtlGJRaqw9CQvHeW
RBEAnj7CELDQ+XLUZV+sqkEa04Ky6ndc
=kFse
-----END PGP SIGNATURE-----

------enig2WUSGCNSSCTXIHIQWTIFL--
