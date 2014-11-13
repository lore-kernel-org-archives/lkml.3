Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaKMK6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:58:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59191 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbaKMK6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:58:40 -0500
Message-ID: <54648ED8.7030608@atmel.com>
Date: Thu, 13 Nov 2014 11:58:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] irqchip: atmel-aic: add RTT irq fixup
References: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com> <20141109045550.GS3698@titan.lakedaemon.net>
In-Reply-To: <20141109045550.GS3698@titan.lakedaemon.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:55, Jason Cooper :
> On Mon, Nov 03, 2014 at 09:30:59AM +0100, Boris Brezillon wrote:
>> Hello,
>>
>> This patch series add a new fixup function for the RTT (Real Time Timer)
>> block and make use of it on SoCs integrating at least one RTT to prevent
>> spurious interrupts on the first interrupt line.
>>
>> This fixup function was previously implemented in
>> arch/arm/mach-at91/sysirq_mask.c, but is now moved to the AIC driver so
>> that we can remove SoC specific hooks in arch/arm/mach-at91/ when booting
>> a DT kernel.
>>
>> This series also reworks the naming convention of the SoC specific fixup
>> functions and add an entry for the at91rm9200.
>>
>> Best Regards,
>>
>> Boris
>>
>> Changes since v1:
>> - rebased on linux-3.18-rc2
>>
>> Boris BREZILLON (5):
>>   irqchip: atmel-aic: add irq fixup for RTT block
>>   irqchip: atmel-aic: add irq fixups for at91sam926x SoCs
>>   irqchip: atmel-aic: add specific irq fixup function for sam9g45 and
>>     sam9rl
>>   irqchip: atmel-aic: rename at91sam9_aic_irq_fixup for naming
>>     consistency
>>   irqchip: atmel-aic: add missing entry for rm9200 irq fixups
>>
>>  drivers/irqchip/irq-atmel-aic-common.c | 26 ++++++++++++++++++++++++++
>>  drivers/irqchip/irq-atmel-aic-common.h |  2 ++
>>  drivers/irqchip/irq-atmel-aic.c        | 26 +++++++++++++++++++++-----
>>  3 files changed, 49 insertions(+), 5 deletions(-)
> 
> Whole series applied to irqchip/atmel

Too late but for the record:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

There are a little tiny details that I can solve later (function names,
order of SoCs, etc.).

Bye,
-- 
Nicolas Ferre
