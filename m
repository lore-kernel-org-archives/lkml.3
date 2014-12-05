Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaLEKKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:10:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45085 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaLEKKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:10:38 -0500
Message-ID: <54818495.5010700@arm.com>
Date: Fri, 05 Dec 2014 10:10:29 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stuart Yoder <b08248@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 09/13] irqchip: GICv3: ITS: MSI support
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>	<1416839720-18400-10-git-send-email-marc.zyngier@arm.com> <CALRxmdAULDXqx5oNUGQx9y2oUegULKO7=gWQWMRkFOzFo9XS8A@mail.gmail.com>
In-Reply-To: <CALRxmdAULDXqx5oNUGQx9y2oUegULKO7=gWQWMRkFOzFo9XS8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stuart,

On 04/12/14 21:52, Stuart Yoder wrote:
> On Mon, Nov 24, 2014 at 8:35 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
>> +/*
>> + * We need a value to serve as a irq-type for LPIs. Choose one that will
>> + * hopefully pique the interest of the reviewer.
>> + */
>> +#define GIC_IRQ_TYPE_LPI               0xa110c8ed
> 
> Ok, my interest is piqued.  Why this value?

See the xlate function in the main GICv3 driver.

We need something to indicate that we want it to allocate an LPI, but
this function is mostly DT-specific, and we don't have an LPI type in
the binding just yet (I've purposely pushed back on it until we have a
clear idea of where we want to take LPIs).

So this value is just a made up thing that is unlikely to ever find its
place in a DT binding.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
