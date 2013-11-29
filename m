Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3K2Jjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:39:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33940 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3K2Jja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:39:30 -0500
Message-ID: <5298601F.4090200@ti.com>
Date: Fri, 29 Nov 2013 11:36:31 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v2] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com> <52981A4B.70703@ti.com>
In-Reply-To: <52981A4B.70703@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 06:38 AM, Sekhar Nori wrote:
> On Wednesday 27 November 2013 08:01 PM, Ivan Khoronzhuk wrote:
>> The problem that the set timings code contains the call of Davinci
>> platform function davinci_aemif_setup_timing() which is not
>> accessible if kernel is built for another platform like Keystone.
>>
>> The Keysone platform is going to use TI AEMIF driver.
>> If TI AEMIF is used we don't need to set timings and bus width.
>> It is done by AEMIF driver.
>>
>> To get rid of davinci-nand driver dependency on aemif platform code
>> we moved aemif code to davinci platform.
>>
>> The platform AEMIF code (aemif.c) has to be removed once Davinci
>> will be converted to DT and use ti-aemif.c driver.
>>
>> The long device name "davinci_ntosd2_nandflash_device" was renamed
>> to "ntosd2_nandflash" as requested by Sekhar Nori, because after
>> adding changes the line is so broken that its almost unreadable.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> 
> This patch can be simplified in some places.
> 
>> ---
>> v2..v1:
>> - enabled AEMIF clock
>> - removed EXPORT_SYMBOL(davinci_aemif_setup)
>> - renamed ugly name davinci_ntosd2_nandflash_device
>>
>> CC:
>> Sekhar Nori <nsekhar@ti.com>
>>
>>   arch/arm/mach-davinci/aemif.c                   |   89 ++++++++++++++++++++++-
>>   arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>>   arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>>   arch/arm/mach-davinci/board-dm355-evm.c         |    5 ++
>>   arch/arm/mach-davinci/board-dm355-leopard.c     |    5 ++
>>   arch/arm/mach-davinci/board-dm365-evm.c         |    4 +
>>   arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>>   arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
>>   arch/arm/mach-davinci/board-mityomapl138.c      |    3 +
>>   arch/arm/mach-davinci/board-neuros-osd2.c       |   13 +++-
>>   arch/arm/mach-davinci/devices-tnetv107x.c       |    3 +
>>   drivers/mtd/nand/davinci_nand.c                 |   23 ------
>>   include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
> 
> Most of these boards dont really have a timing structure defined.
> Instead of blindly calling AEMIF setup on all boards, it can be
> done only on boards that actually need it.
> 

Yes, but in such case we should add AEMIF setup to
arch/arm/mach-davinci/board-mityomapl138.c also,
because it has: .options = NAND_BUSWIDTH_16

-- 
Regards,
Ivan Khoronzhuk
