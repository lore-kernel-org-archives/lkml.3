Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3IPKep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:34:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56020 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3IPKeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:34:44 -0400
Message-ID: <5236DEBF.7070003@ti.com>
Date: Mon, 16 Sep 2013 13:34:39 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <monstr@monstr.eu>
CC: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com> <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com> <5236D4BD.9050707@ti.com> <5236DE60.3020901@monstr.eu>
In-Reply-To: <5236DE60.3020901@monstr.eu>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iwJUlIJREr1fXdUdv73R1xOb4tMf58sSc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iwJUlIJREr1fXdUdv73R1xOb4tMf58sSc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 16/09/13 13:33, Michal Simek wrote:
> On 09/16/2013 11:51 AM, Tomi Valkeinen wrote:
>> On 12/09/13 08:54, Michal Simek wrote:
>>
>>> @@ -394,16 +382,12 @@ static int xilinxfb_release(struct device *dev)=

>>>  	/* Turn off the display */
>>>  	xilinx_fb_out32(drvdata, REG_CTRL, 0);
>>>
>>> -	/* Release the resources, as allocated based on interface */
>>> -	if (drvdata->flags & BUS_ACCESS_FLAG)
>>> -		devm_iounmap(dev, drvdata->regs);
>>>  #ifdef CONFIG_PPC_DCR
>>> -	else
>>> +	/* Release the resources, as allocated based on interface */
>>> +	if (!(drvdata->flags & BUS_ACCESS_FLAG))
>>>  		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
>>>  #endif
>>
>> I might be mistaken, and it's not strictly part of this series, but
>> shouldn't dcr_unmap be called somewhere else also, if the probe fails?=

>=20
> yes. It should.

Do you want me to apply these patches as they are, or do you want to
improve the series to include the dcr_unmap fix?

 Tomi



--iwJUlIJREr1fXdUdv73R1xOb4tMf58sSc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSNt6/AAoJEPo9qoy8lh71h7QP/irrUQWcEEvL8lvo/6yX0sC4
nTwE2OTGcnVZXbyRRabSqx/MQ1mmliwd1w8wPFXj1i03qh4b4inpHLvJ28ArmBbJ
WMEs5AcKhnigg19Z6UNyUjOtn4rvMb7qdBVsMjNewLsFSkUXU4+JpriDuaJrwczE
K2qTSeOxae1Gi51SMGNEF53RSQeeAqMLYzkbrltM5pWsRkyQamOLf6nJwZ4No+zu
uD45aB12rYLWKKJzDpOfz59e1gGqHoQ2aauEsbdEZCduntVinCj7HToHJvuqxCA7
A9ASUhwRKQm7MtBkuY8O8HAxSCjUSpiLV9szJuU2lRP1cy/cxINssguZMRuIEUDc
8mz/Ez3wCdl7BHDYExJuxjn7EW6E2Jk1mbh5YyV8Q4FEn3QQGGx5QTKgWecmfDND
ffFrprmqbKOa4OUhl2gWWUArCcEuqlmgIyr7PxldgIK+dVjsl1KdRCYqbfqRI9de
D6siFCf1hBvXC4p3BNFB6J1dOxdePJ+SSl4qXrGjfx9iKM7vYhb2xgR3Vg/9BTIf
4yqoiC7USXifcFKBqQepWt2LDsBQ9P9wbRBa6GoxrEv/oOQ/0rNTu3lpQj8psZ/c
zuznEdarKs5tF4pmNfklVL/WtvbPTMNBkHRAmsxnxw5E/TWkoGkzzhgKDAr4Ixvs
m9z7A/LUQIHoJOUCz62R
=SXD3
-----END PGP SIGNATURE-----

--iwJUlIJREr1fXdUdv73R1xOb4tMf58sSc--
