Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667Ab3BNOcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:32:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab3BNOcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:32:52 -0500
Date: Thu, 14 Feb 2013 15:37:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 -tip] sched/rt: Fix locality of threaded interrupt
 handlers
Message-ID: <20130214143712.GA31777@dhcp-26-207.brq.redhat.com>
References: <6b08a3c5c16284fd0221c2b564d451b4b9dcbf18.1357896654.git.agordeev@redhat.com>
 <alpine.LFD.2.02.1301141217300.7475@ionos>
 <20130114141152.GB7048@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114141152.GB7048@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 03:11:52PM +0100, Alexander Gordeev wrote:
> When a interrupt affinity mask targets multiple CPUs, the
> RT scheduler selects a runqueue for RT task corresponding
> to a threaded interrupt handler without consideration of
> where the interrupt is actually gets delivered. It leads
> to a suboptimal condition when a hardware interrupt handler
> executes on one CPU while the threaded interrupt handler
> executes on another CPU.
> 
> This fix alters the behaviour of threaded handler wake-ups
> by getting priority to a CPU where the hardware interrupt
> handler is executing. As result, most of the time both
> halves of interrupt handling are kept local.

Hi Thomas, Ingo,

Would you ack/consider this patch?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
