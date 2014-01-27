Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaA0UWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:22:55 -0500
Received: from one.firstfloor.org ([193.170.194.197]:58270 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaA0UWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:22:54 -0500
Date: Mon, 27 Jan 2014 21:22:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
Message-ID: <20140127202252.GA11821@two.firstfloor.org>
References: <52E6AFFE.3030004@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E6AFFE.3030004@siemens.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:14:06PM +0100, Jan Kiszka wrote:
> apic_icr_write and its users in smpboot.c were apparently written under
> the assumption that this code would only run during early boot. But
> nowadays we also execute it when onlining a CPU later on while the
> system is fully running. That will make wakeup_cpu_via_init_nmi and,
> thus, also native_apic_icr_write run in plain process context. If we
> migrate the caller to a different CPU at the wrong time or interrupt it
> and write to ICR/ICR2 to send unrelated IPIs, we can end up sending
> INIT, SIPI or NMIs to wrong CPUs.
> 
> Fix this by disabling interrupts during the write to the ICR halves and
> disable preemption around waiting for ICR availability and using it.

If you just want to disable migration use get_cpu()/put_cpu()

-Andi
