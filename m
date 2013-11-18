Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3KROJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:09:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3KROI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:08:58 -0500
Message-ID: <528A1F4D.6050404@ti.com>
Date: Mon, 18 Nov 2013 09:08:13 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF
 is used
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D53@DNCE04.ent.ti.com> <528253B7.2060408@ti.com> <5289FB9C.6060204@ti.com>
In-Reply-To: <5289FB9C.6060204@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 November 2013 06:35 AM, Grygorii Strashko wrote:
> On 11/12/2013 06:13 PM, Santosh Shilimkar wrote:
>> On Monday 11 November 2013 12:10 PM, Khoronzhuk, Ivan wrote:
>>> If Davinci AEMIF is used we don't need to set timings and bus width.
>>> It is done by AEMIF driver (drivers/memory/davinci-aemfi.c).
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>>>   drivers/mtd/nand/davinci_nand.c |   22 +++++++++++++++-------
>>>   1 file changed, 15 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>>> index 4705214..879e915 100644
>>> --- a/drivers/mtd/nand/davinci_nand.c
>>> +++ b/drivers/mtd/nand/davinci_nand.c
>>> @@ -742,27 +742,35 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>>>                  goto err_clk_enable;
>>>          }
>>>
>>> +#if !IS_ENABLED(CONFIG_TI_DAVINCI_AEMIF)
>>>
>> Instead above #if, just use a variable.
>>     bool aemif = IS_ENABLED(CONFIG_TI_DAVINCI_AEMIF) and then skip
>> the below code. #if block in the middle of the code looks ugly.
> 
> Yes, this is the hack.
> The problem is that this part of code contains the call of Davinci platform function davinci_aemif_setup_timing() which is not accessible if Kernel is built for Keystone only.
> That's why "#if" has been used.
> 
> This part of code has to be removed together with Davinci aemif platform code (aemif.c), once Davinci will be converted to DT and use
> new driver.
> 
> The corresponding comment can be added here. Is it ok?
> 
Thats more or less what I proposed in another reply. Lets clearly
document it on why such a check was added.

Regards,
Santosh

