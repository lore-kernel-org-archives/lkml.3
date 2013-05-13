Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab3EMLnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:43:19 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58496 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3EMLnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130512152829.GA17866@merkur.ravnborg.org>
References: <1368367807-1263-1-git-send-email-laurent.navet@gmail.com>
	<20130512152829.GA17866@merkur.ravnborg.org>
Date: Mon, 13 May 2013 13:43:17 +0200
Message-ID: <CAH7P7NjHK+QQ1E1ygCG0u=oEL1=Dty__OAZfYA1bitPm_cY3Yw@mail.gmail.com>
Subject: Re: [PATCH] arch: sparc: kernel: use devm_ioremap_resource()
From: Laurent Navet <laurent.navet@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: davem@davemloft.net, daniel@gaisler.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same is done almost everywhere in kernel tree :

e.g :
http://lxr.free-electrons.com/source/drivers/staging/iio/adc/mxs-lradc.c#L928
http://lxr.free-electrons.com/source/drivers/gpio/gpio-mxs.c#L292
http://lxr.free-electrons.com/source/drivers/iommu/tegra-smmu.c#L1181
http://lxr.free-electrons.com/source/drivers/rtc/rtc-spear.c#L388
http://lxr.free-electrons.com/source/drivers/i2c/busses/i2c-imx.c#L514
http://lxr.free-electrons.com/source/sound/soc/kirkwood/kirkwood-i2s.c#L475

and so on...  all theses functions return an int.

Regards,
Laurent.

2013/5/12, Sam Ravnborg <sam@ravnborg.org>:
> On Sun, May 12, 2013 at 04:10:07PM +0200, Laurent Navet wrote:
>> Replace a call to deprecated devm_request_and_ioremap by
>> devm_ioremap_resource.
>>
>> Found with coccicheck and this semantic patch:
>>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
>>
>> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
>> ---
>>  arch/sparc/kernel/leon_pci_grpci1.c |    8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/sparc/kernel/leon_pci_grpci1.c
>> b/arch/sparc/kernel/leon_pci_grpci1.c
>> index 7739a54..6df26e3 100644
>> --- a/arch/sparc/kernel/leon_pci_grpci1.c
>> +++ b/arch/sparc/kernel/leon_pci_grpci1.c
>> @@ -536,11 +536,9 @@ static int grpci1_of_probe(struct platform_device
>> *ofdev)
>>
>>  	/* find device register base address */
>>  	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
>> -	regs = devm_request_and_ioremap(&ofdev->dev, res);
>> -	if (!regs) {
>> -		dev_err(&ofdev->dev, "io-regs mapping failed\n");
>> -		return -EADDRNOTAVAIL;
>> -	}
>> +	regs = devm_ioremap_resource(&ofdev->dev, res);
>> +	if (IS_ERR(regs))
>> +		return PTR_ERR(regs);
>
> This looks bogus. The function return an int - not a pointer.
>
> 	Sam
>


-- 
« On ne résout pas un problème avec les modes de pensée qui l’ont engendré. »
« You cannot solve current problems with current thinking. Current
problems are the result of current thinking »
