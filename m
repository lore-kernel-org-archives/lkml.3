Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3HSKS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:18:26 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:5422 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3HSKSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:18:25 -0400
Message-ID: <5211F0D6.40207@bfs.de>
Date: Mon, 19 Aug 2013 12:17:58 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] regulator: ti-abb: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-6-git-send-email-Julia.Lawall@lip6.fr> <5211E111.4060406@bfs.de> <alpine.DEB.2.02.1308191210300.2313@hadrien>
In-Reply-To: <alpine.DEB.2.02.1308191210300.2313@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 19.08.2013 12:12, schrieb Julia Lawall:
> On Mon, 19 Aug 2013, walter harms wrote:
> 
>>
>>
>> Am 19.08.2013 10:51, schrieb Julia Lawall:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Remove unneeded error handling on the result of a call to
>>> platform_get_resource_byname when the value is passed to devm_ioremap_resource.
>>>
>>> A simplified version of the semantic patch that makes this change is as
>>> follows: (http://coccinelle.lip6.fr/)
>>>
>>> // <smpl>
>>> @@
>>> expression pdev,res,e,e1;
>>> expression ret != 0;
>>> identifier l;
>>> @@
>>>
>>>   res = platform_get_resource_byname(...);
>>> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>>>   e = devm_ioremap_resource(e1, res);
>>> // </smpl>
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> ---
>>>  drivers/regulator/ti-abb-regulator.c |   10 ----------
>>>  1 file changed, 10 deletions(-)
>>>
>>> diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
>>> index 3753ed0..d8e3e12 100644
>>> --- a/drivers/regulator/ti-abb-regulator.c
>>> +++ b/drivers/regulator/ti-abb-regulator.c
>>> @@ -717,11 +717,6 @@ static int ti_abb_probe(struct platform_device *pdev)
>>>  	/* Map ABB resources */
>>>  	pname = "base-address";
>>>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
>>> -	if (!res) {
>>> -		dev_err(dev, "Missing '%s' IO resource\n", pname);
>>> -		ret = -ENODEV;
>>> -		goto err;
>>> -	}
>>>  	abb->base = devm_ioremap_resource(dev, res);
>>>  	if (IS_ERR(abb->base)) {
>>>  		ret = PTR_ERR(abb->base);
>>
>>
>> is pname used by anything else ? (also below)
> 
> I'm not sure to understand the sense of the question.  My patch does
> remove a use of pname, but there is another one on the line above, in the
> call to platform_get_resource_byname.  Perhaps the definition of pname
> could be inlined at this use, but it is a common pattern throughout the
> function.
> 
in other functions this looks like that:
r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");

i did not dive into the driver but from the part i see makeing this into:

 es = platform_get_resource_byname(pdev, IORESOURCE_MEM,"base-address");

would render pname obsolete.

re,
 wh
