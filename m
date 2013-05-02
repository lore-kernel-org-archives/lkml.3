Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761827Ab3EBSqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:46:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42880 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761815Ab3EBSqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:46:37 -0400
Date: Thu, 2 May 2013 19:45:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Message-ID: <20130502184514.GE14496@n2100.arm.linux.org.uk>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <5182B18C.4080404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182B18C.4080404@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 08:33:48PM +0200, Sebastian Hesselbarth wrote:
> On 05/02/2013 08:25 PM, Sebastian Hesselbarth wrote:
>> This patch adds an irqchip driver for the main interrupt controller found
>> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
>> Corresponding device tree documentation is also added.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> ---
>> Note: This patch triggers a checkpatch warning for
>>    WARNING: Avoid CamelCase:<handle_IRQ>
>>
> [...]
>> diff --git a/include/linux/irqchip/orion.h b/include/linux/irqchip/orion.h
>> new file mode 100644
>> index 0000000..04f7bab
>> --- /dev/null
>> +++ b/include/linux/irqchip/orion.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * Marvell Orion SoCs IRQ chip driver header.
>> + *
>> + * Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef __LINUX_IRQCHIP_ORION_H
>> +#define __LINUX_IRQCHIP_ORION_H
>> +
>> +#include<asm/exception.h>
>
> First review by myself. The above include is a left-over and
> will be removed in a v2.

You still need your first level IRQ handlers marked with __exception_irq_entry
which is defined in the above file.
