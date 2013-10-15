Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3JOX76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:59:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759838Ab3JOX75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:59:57 -0400
Message-ID: <525DD612.6050409@zytor.com>
Date: Tue, 15 Oct 2013 16:56:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
CC: rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de, tglx@linutronix.de,
        fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: Re: [PATCH v3] Introduce page fault tracepoint
References: <522E43D5.9010505@hds.com>
In-Reply-To: <522E43D5.9010505@hds.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 02:55 PM, Seiji Aguchi wrote:
> Change from v2
>  - Print entry->ip instead of entry->regs->ip to avoid kernel crash.
>  - Use %pf instead of 0x%lx to print address and ip.
> 
> This patch introduces page fault tracepoints to x86 architecture
> by switching IDT.
> 
> [Use case of page fault events]
> 
>   Two events, for user and kernel spaces, are introduced at the beginning of
>   page fault handler.
> 
>   - User space event
>     There is a request of page fault event for user space as below.
> 
>     http://marc.info/?l=linux-mm&m=136807959830182&w=2
>     http://marc.info/?l=linux-mm&m=136807959130175&w=2
> 

For permanence, please use links of the form:

	http://lkml.kernel.org/r/message-id

(Yes, they currently point to marc.info, but can be redirected to point
to any archive.)

>   - Kernel space event:
>     Overhead in kernel space is measurable by enabling it.
> 
> [Creating IDT]
> 
>  A way to create IDT is as below.
> 
>  - Introduce set_intr_gate_raw() to register just non-trace handler to IDT.
>    This is used at boot time which tracing is disabled.
>  - Make set_intr_gate() macro so that it can register trace handler to
>    trace IDT and non-trace handler to normal IDT.
> 

This is needlessly confusing, which is apart of why reviewing this patch
took a lot more time than it should.

Please break this patch into two: one which sets up the tracing IDT and
one to create the #PF tracepoint.  The assumption is, I am assuming,
there will be more.

	-hpa

