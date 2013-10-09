Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3JIK0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:26:01 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54574 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3JIKZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:25:59 -0400
Message-ID: <52552F2E.7080007@monstr.eu>
Date: Wed, 09 Oct 2013 12:25:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com> <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com> <5236D4BD.9050707@ti.com> <5236DE60.3020901@monstr.eu> <5236DEBF.7070003@ti.com> <52496921.9080603@monstr.eu> <52551BAB.40805@ti.com>
In-Reply-To: <52551BAB.40805@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="W0u64NRjCG7Tx0BFFb7bUPXGaf2J9EwaB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W0u64NRjCG7Tx0BFFb7bUPXGaf2J9EwaB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/09/2013 11:02 AM, Tomi Valkeinen wrote:
> On 30/09/13 15:05, Michal Simek wrote:
>> Hi Tomi,
>>
>> On 09/16/2013 12:34 PM, Tomi Valkeinen wrote:
>>> On 16/09/13 13:33, Michal Simek wrote:
>>>> On 09/16/2013 11:51 AM, Tomi Valkeinen wrote:
>>>>> On 12/09/13 08:54, Michal Simek wrote:
>>>>>
>>>>>> @@ -394,16 +382,12 @@ static int xilinxfb_release(struct device *d=
ev)
>>>>>>  	/* Turn off the display */
>>>>>>  	xilinx_fb_out32(drvdata, REG_CTRL, 0);
>>>>>>
>>>>>> -	/* Release the resources, as allocated based on interface */
>>>>>> -	if (drvdata->flags & BUS_ACCESS_FLAG)
>>>>>> -		devm_iounmap(dev, drvdata->regs);
>>>>>>  #ifdef CONFIG_PPC_DCR
>>>>>> -	else
>>>>>> +	/* Release the resources, as allocated based on interface */
>>>>>> +	if (!(drvdata->flags & BUS_ACCESS_FLAG))
>>>>>>  		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
>>>>>>  #endif
>>>>>
>>>>> I might be mistaken, and it's not strictly part of this series, but=

>>>>> shouldn't dcr_unmap be called somewhere else also, if the probe fai=
ls?
>>>>
>>>> yes. It should.
>>>
>>> Do you want me to apply these patches as they are, or do you want to
>>> improve the series to include the dcr_unmap fix?
>>
>> Sorry I have missed this email.
>>
>> Yes please apply it as is. I don't have ppc hw here to be able to test=
 this
>> change.
>=20
> This series does not apply. Can you rebase on top of linux-next, and re=
send?

Do you mean Stephen Rothwell linux-next or any your linux-next branch?
No problem to do so if you send me link to the repo.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--W0u64NRjCG7Tx0BFFb7bUPXGaf2J9EwaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJVLy4ACgkQykllyylKDCEI8wCcDywJY4UYFEwdjCSYuVyTAn3m
ejAAn24z3Vla3ldZENVcAgHY8i3ZeXjN
=rUv+
-----END PGP SIGNATURE-----

--W0u64NRjCG7Tx0BFFb7bUPXGaf2J9EwaB--
