Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LQKXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:23:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36686 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:23:16 -0500
Message-ID: <52B02598.5060004@ti.com>
Date: Tue, 17 Dec 2013 12:21:12 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH v3 1/9] mtd: nand: davinci: fix driver registration
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com> <1386264358-9738-2-git-send-email-ivan.khoronzhuk@ti.com> <20131217092449.GL12034@norris-Latitude-E6410>
In-Reply-To: <20131217092449.GL12034@norris-Latitude-E6410>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 11:24 AM, Brian Norris wrote:
> On Thu, Dec 05, 2013 at 07:25:49PM +0200, Ivan Khoronzhuk wrote:
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -877,6 +877,7 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
>>   }
>>   
>>   static struct platform_driver nand_davinci_driver = {
>> +	.probe		= nand_davinci_probe,
>>   	.remove		= __exit_p(nand_davinci_remove),
> 
> I believe you need to drop the __exit_p() here. And now that you're
> using module_platform_driver(), you need to drop the __init and __exit
> from the probe() and remove() routines, to avoid section mismatch
> warnings.
> 
>>   	.driver		= {
>>   		.name	= "davinci_nand",
> 
> So on second thought, please resubmit the series with the requested
> changes.
> 
> Thanks,
> Brian
> 

Thanks, Brian.
Do you want me to drop it in stand alone patch or in this one?

-- 
Regards,
Ivan Khoronzhuk
