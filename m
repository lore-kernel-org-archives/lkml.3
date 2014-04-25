Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaDYIBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:01:46 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50454 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaDYIBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:01:43 -0400
Date: Fri, 25 Apr 2014 10:01:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140425080137.GC19588@gmail.com>
References: <1398376326-3055-1-git-send-email-oren@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398376326-3055-1-git-send-email-oren@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Twaig <oren@scalemp.com> wrote:

> vSMP Foundation provides locality based interrupt routing which needed
> vector_allocation_domain to allow all online cpus can handle all possible
> vectors. 
> 
> Enforcing Interrupt Routing Comply (IRC) mode requires us to unplug this hook as
> otherwise the IOAPIC, MSI and MSIX destination selectors to always select the
> lowest online cpu as the destination. I.e affinity of HW interrupts cannot be
> controled by kernel and/or userspace code.
> 
> The purpose of the patch is to fix the code to set override vector allocation
> domain only when IRC is set to ignore to allow the kernel and userspace to
> effectively control the destination of the HW interrupts.
> 
> Signed-off-by: Oren Twaig <oren@scalemp.com>
> Acked-by: Shai Fultheim <shai@scalemp.com>

So what was the behavior before the change - certain IRQs did not get 
routed, they just ended up on CPU0 or on some other undesirable CPU? 
Or was IRQ distribution random? It's not clear from the changelog.

Thanks,

	Ingo
