Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3GLLNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:13:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35691 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab3GLLN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:13:29 -0400
Date: Fri, 12 Jul 2013 12:13:22 +0100
From: Javi Merino <javi.merino@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if UP
 system
Message-ID: <20130712111322.GC3213@e102654-lin.cambridge.arm.com>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Jul 2013 11:13:23.0709 (UTC) FILETIME=[D2F8BAD0:01CE7EF0]
X-MC-Unique: 113071212132700201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:39:33AM +0100, Stephen Boyd wrote:
> In a uniprocessor implementation the interrupt processor targets
> registers are read-as-zero/write-ignored (RAZ/WI). Unfortunately
> gic_get_cpumask() will print a critical message saying
> 
>  GIC CPU mask not found - kernel will fail to boot.
> 
> if these registers all read as zero, but there won't actually be
> a problem on uniprocessor systems and the kernel will boot just
> fine. Skip this check if we're running a UP kernel or if we
> detect that the hardware only supports a single processor.
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Maybe we should just drop the check entirely? It looks like it may
> just be debug code that won't ever trigger in practice, even on the
> 11MPCore that caused this code to be introduced.

I agree, we should drop the check.  It's annoying in uniprocessors and
unlikely to be found in the real world unless your gic entry in the dt
is wrong.

