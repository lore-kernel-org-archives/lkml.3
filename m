Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3LQKn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:43:27 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64460 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3LQKnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:43:25 -0500
MIME-Version: 1.0
In-Reply-To: <52B02598.5060004@ti.com>
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
	<1386264358-9738-2-git-send-email-ivan.khoronzhuk@ti.com>
	<20131217092449.GL12034@norris-Latitude-E6410>
	<52B02598.5060004@ti.com>
Date: Tue, 17 Dec 2013 02:43:24 -0800
Message-ID: <CAN8TOE-DA8pQC2tt6M8ygGaioiDCvRqnwMU_GtWX6BR45Dvhhg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] mtd: nand: davinci: fix driver registration
From: Brian Norris <computersforpeace@gmail.com>
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 2:21 AM, ivan.khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
> On 12/17/2013 11:24 AM, Brian Norris wrote:
>> On Thu, Dec 05, 2013 at 07:25:49PM +0200, Ivan Khoronzhuk wrote:
>>> --- a/drivers/mtd/nand/davinci_nand.c
>>> +++ b/drivers/mtd/nand/davinci_nand.c
>>> @@ -877,6 +877,7 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
>>>   }
>>>
>>>   static struct platform_driver nand_davinci_driver = {
>>> +    .probe          = nand_davinci_probe,
>>>      .remove         = __exit_p(nand_davinci_remove),
>>
>> I believe you need to drop the __exit_p() here. And now that you're
>> using module_platform_driver(), you need to drop the __init and __exit
>> from the probe() and remove() routines, to avoid section mismatch
>> warnings.
>
> Do you want me to drop it in stand alone patch or in this one?

I think you can just do the __exit_p()/__init/__exit removal all in
this same patch. The changes are all inter-related.

Brian
