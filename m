Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab3KMOPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:15:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43841 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3KMOPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:15:12 -0500
Message-ID: <52838941.4060207@ti.com>
Date: Wed, 13 Nov 2013 09:14:25 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF
 is used
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D53@DNCE04.ent.ti.com> <528307F0.6000805@ti.com>
In-Reply-To: <528307F0.6000805@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013 12:02 AM, Sekhar Nori wrote:
> On Monday 11 November 2013 10:40 PM, Khoronzhuk, Ivan wrote:
>> If Davinci AEMIF is used we don't need to set timings and bus width.
>> It is done by AEMIF driver (drivers/memory/davinci-aemfi.c).
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>  drivers/mtd/nand/davinci_nand.c |   22 +++++++++++++++-------
>>  1 file changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> index 4705214..879e915 100644
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -742,27 +742,35 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>>                 goto err_clk_enable;
>>         }
>>
>> +#if !IS_ENABLED(CONFIG_TI_DAVINCI_AEMIF)
> 
> This is a hack! Just because AEMIF driver is enabled, it does not
> guarantee that the timings have been setup by it. Instead of configuring
> timings in two drivers, why not just convert everyone over to use the
> new driver. Dont worry about breaking old platforms, I will help test
> and ack them.
> 
How about you take a stab at and convert the DaVinci code over to make
use of new driver. We are trying to re-use as much as possible from the
common drivers and also making an option so that the DaVinci arch can
move over to these drivers if they want to.

Thanks.

Regards,
Santosh

