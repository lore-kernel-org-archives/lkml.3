Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaKSIzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:55:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32986 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaKSIza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:55:30 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: "Yun Wu \(Abel\)" <wuyun.wu@huawei.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
In-Reply-To: <546C10A1.9040704@huawei.com> (Yun Wu's message of "Wed, 19 Nov
	2014 03:38:09 +0000")
Organization: ARM Ltd
References: <20141112133941.647950773@linutronix.de>
	<20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com>
	<alpine.DEB.2.11.1411181103360.3909@nanos>
	<546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com>
	<546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com>
	<546B5635.6020806@huawei.com> <546B57E4.9040804@linux.intel.com>
	<546B5BAA.9090905@huawei.com>
	<87a93oe8is.fsf@approximate.cambridge.arm.com>
	<546C10A1.9040704@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Wed, 19 Nov 2014 08:55:21 +0000
Message-ID: <87mw7nd0xy.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2014 at  3:38:09 am GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
> On 2014/11/19 1:14, Marc Zyngier wrote:
>
>> On Tue, Nov 18 2014 at  2:46:02 pm GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
> [...]
>>> IIUC, Marc's patch now only supports PCI MSI/MSI-X...
>> 
>> Indeed, and the current solution makes is relatively easy to plug in
>> non-PCI MSI. Just don't plug the ITS into the *PCI* MSI framework when
>> you encounter such a thing.
>> 
>
> I am looking forward to that. :)

I really don't.

> I guess the main reason you haven't plugged in non-PCI MSI is the way
> of obtaining device ids used in searching DT table.

That, and also:
- No way to carve out LPI ranges for non-PCI allocations, should some
ITS mandate specific ranges
- No description of how to program the generating device, it required
- No platform with such requirements aiming for upstream support

To put it mildly, non-PCI support on the ITS is a rather long way
away, and it has nothing to do with the code. It has everything to do
with specifying what we want to support, and how we describe it in
DT. Until then, not much is going to happen.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
