Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab3GRHDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:03:06 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45356 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab3GRHDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:03:04 -0400
Message-ID: <51E7931D.80801@monstr.eu>
Date: Thu, 18 Jul 2013 09:02:53 +0200
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
References: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com> <20130530201714.GE19834@game.jcrosoft.org> <51A85BEE.4000009@monstr.eu> <20130531110045.GF19834@game.jcrosoft.org> <51A8AC4B.906@monstr.eu> <20130531151601.GG19834@game.jcrosoft.org> <51A8D3A3.5030200@monstr.eu> <20130606082941.GH19834@game.jcrosoft.org> <51B04AA9.4070803@monstr.eu> <20130606144929.GI19834@game.jcrosoft.org>
In-Reply-To: <20130606144929.GI19834@game.jcrosoft.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LHULNEERAAQPVTTJAXXJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LHULNEERAAQPVTTJAXXJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/06/2013 04:49 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:39 Thu 06 Jun     , Michal Simek wrote:
>> On 06/06/2013 10:29 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> On 18:45 Fri 31 May     , Michal Simek wrote:
>>>> On 05/31/2013 05:16 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>> On 15:57 Fri 31 May     , Michal Simek wrote:
>>>>>> On 05/31/2013 01:00 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>>>> On 10:14 Fri 31 May     , Michal Simek wrote:
>>>>>>>> Hi Jean-Christophe,
>>>>>>>>
>>>>>>>> On 05/30/2013 10:17 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>>>>>> On 15:49 Thu 30 May     , Michal Simek wrote:
>>>>>>>>>> Export of_irq_count for modules.
>>>>>>>>>
>>>>>>>>> can you explain why do you need to call of_irq_count
>>>>>>>>
>>>>>>>> I need to count number of irq written in the DTS node.
>>>>>>>> It is not fixed size that's why I need to proper way how to
>>>>>>>> find it out.
>>>>>>>>
>>>>>>>> I am using this loop.
>>>>>>>> 	count =3D of_irq_count(pdev->dev.of_node);
>>>>>>>> 	/* Alloc IRQ based on DTS to be sure that no other driver will =
use it */
>>>>>>>> 	while (count--) {
>>>>>>>> 		tmp->irq =3D irq_of_parse_and_map(pdev->dev.of_node, count);
>>>>>>>> 		dev_info(&pdev->dev, "%d: Alloc irq: %d\n", count, tmp->irq);
>>>>>>>> 		ret =3D request_irq(tmp->irq, zynq_remoteproc_interrupt, 0,
>>>>>>>> 					dev_name(&pdev->dev), &pdev->dev);
>>>>>>>> 		if (ret) {
>>>>>>>> 			...
>>>>>>>> 		}
>>>>>>>> 	}
>>>>>>>>
>>>>>>>> But of course if you think that this is incorrect to export it
>>>>>>>> I can use what it is in of_irq_count body
>>>>>>>> 368 int of_irq_count(struct device_node *dev)
>>>>>>>> 369 {
>>>>>>>> 370         int nr =3D 0;
>>>>>>>> 371
>>>>>>>> 372         while (of_irq_to_resource(dev, nr, NULL))
>>>>>>>> 373                 nr++;
>>>>>>>> 374
>>>>>>>> 375         return nr;
>>>>>>>> 376 }
>>>>>>>>
>>>>>>>> Because of_irq_to_resource is exported for modules.
>>>>>>>> Or is there any better way how to loop over all interrupts in DT=
 node?
>>>>>>>
>>>>>>> can just explain me why you need to call irq_of_parse_and_map in =
your driver?
>>>>>>>
>>>>>>> as the irq will be provided in the resources normally
>>>>>>
>>>>>> It is quite a long time I have written this driver on v3.1 or 3.3.=

>>>>>> But is this better?
>>>>>>
>>>>>> 	struct resource *res;
>>>>>> 	int i =3D 0;
>>>>>> 	do {
>>>>>> 		res =3D platform_get_resource(pdev, IORESOURCE_IRQ, i++);
>>>>>> 		if (res)
>>>>>> 			do something
>>>>>> 	} while(res);
>>>>>>
>>>>>> Also what about of_irq_to_resource()? Is it deprecated and all dri=
vers
>>>>>> shouldn't use it?
>>>>>>
>>>>>> I have no problem to rewrite the driver to use platform_get_resour=
ce.
>>>>> yeah it's better but be aware there is a but in DT that I'm working=
 on to fix
>>>>> if you use irq that are registered by a pdev this will not work
>>>>>
>>>>> I hope to fix it for 3.11
>>>>> and already send an RFC that fix it
>>>>
>>>> ok. good to know. Btw: Let's return to my origin point why not to
>>>> export of_irq_count for modules?
>>>> Or opposite question if platform_get_resource is correct way
>>>> why to export of_irq_to_resource for modules?
>>>
>>> for old ppc drivers that are not converted yet to pdev
>>>
>>> if you can do so just use pdev resource I should have fix the pb or i=
rq_domain
>>> hopefully for 3.11
>>
>> ok. It means it is currently deprecated.
>> I just wanted to be sure that I understand it correctly.
>>
>> I have changed my drivers not to use this function and using resources=
 as
>> we discussed.
>>
>> btw: I have sent one email to device-tree ML about describing missing
>> connection between cpu and the first interrupt controller.
>> Can you please look at it and comment it?
>> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-May/033955.=
html
>=20
> for the record as discussed with Grant I'm preparing to add a new prope=
rty
> to handle interrupts so you will never have to use "interrupt-parent" a=
ny more
> and just do this
>=20
> interrupt-lines =3D <&aic 5 0 &pioA 4>
>=20
> it will be more like gpio and will allow to have irq from different
> interrupt-parent in the same node
>=20
> but wait a few I'll be really back next week as I'm half off this week

Any update on this?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2LHULNEERAAQPVTTJAXXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHnkx4ACgkQykllyylKDCEbswCeJhO0WmJ9jAFsveJtUkE7OtfI
3JUAoJdSmBgwRfQ22IggVEUSh81Rn6Ss
=KXJG
-----END PGP SIGNATURE-----

------enig2LHULNEERAAQPVTTJAXXJ--
