Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaGKMf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:35:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38522 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbaGKMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:35:56 -0400
Date: Fri, 11 Jul 2014 13:35:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liu Hua <sdu.liu@huawei.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "liuxueliu.liu@huawei.com" <liuxueliu.liu@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@huawei.com" <liusdu@huawei.com>, marc.zyngier@arm.com
Subject: Re: [RFC PATCH 0/2] irqchip: GIC: check and clear GIC interupt
 active status
Message-ID: <20140711123507.GE12899@arm.com>
References: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Marc]

On Fri, Jul 11, 2014 at 07:46:15AM +0100, Liu Hua wrote:
> For this version of GIC codes, kernel assumes that all the interrupt
> status of GIC is inactive. So the kernel does not check this when 
> booting.
> 
> This is no problem on must sitations. But when kdump is deplayed.
> And a panic occurs when a interrupt is being handled (may be PPI 
> and SPI). We have no chance to write relative bit to GICC_EOIR.
> So this interrupt remains active. And GIC will not deliver this
> type interrupt to cpu interface. And the capture kernel may 
> fail to boot becase of lacking of certain interrupt (such as timer 
> interupt).
> 
> 
> I glanced over the GIC Architecture Specification, but did not 
> find a simple way to deactive state of all interrupts. For GICv1,
> I can only deal with one abnormal interrupt state one time. For 
> GICv2, I can deactive 32 one time.
> 
> 
> So guys, Do you know a better way to do that? 

What happens if, in the crash kernel, you disable the CPU interfaces
(GICC_CTLR.ENABLE) then disable the distributor (GICD_CTLR.ENABLE) before
enabling everything again in the reverse order? Is that enough to cause the
GIC to drop any active states? It's not clear to me from a quick look at
the TRM.

Will
