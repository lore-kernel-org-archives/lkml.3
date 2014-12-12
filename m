Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLLVqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:46:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59884 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaLLVqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:46:00 -0500
Date: Fri, 12 Dec 2014 22:45:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: Status of tip/x86/apic
Message-ID: <20141212214555.GI30699@pd.tnic>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412121539300.16494@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:35:14PM +0100, Thomas Gleixner wrote:
>       To provide a proper translation into pretty printed values we
>       can do the following:
> 
>        Create a new section for storing such data and have a data
>        structure there which describes the content of the buffer. That
>        section goes into a seperate file and not linked into the
>        kernel binary. Simple enough for tools to pick up and for bug
>        reporters to use/provide. If the stupid file is not available
>        we still can recreate it from source and translate the hex
>        dump.

So maybe we don't need to add that section at all but the script which
parses the buffer should recreate that file simply.

> 	And in the most cases the pure hexdump will be sufficient
>        for the people who need actually to look at this.
> 
>    2) Proper trace point support so we can actually track allocation
>       and the hardware access at the various domain levels because
>       some of these issues cannot be decoded by looking at a state
>       snapshot in debugfs. With some of them we even can't access
>       debugfs at all.
> 
>       Though one issue with that is, that for the early boot process
>       there is no way to store that information as the tracer gets
>       enabled way after init_IRQ(). But there is no reason why the
>       tracer could not be enabled before that. All it needs is a
>       working memory allocator. Steven?
> 
>       Now there is another class of problems which might be hard to
>       debug. When the machine just boots into a hang, so we dont get a
>       ftrace output neither from an oops nor from a console. It would
>       be nice if we could have a command line option which prints
>       enabled trace points via (early_)printk. That would avoid
>       sending out ad hoc printk debug patches which will basically
>       provide the same information as the trace_points. That would be
>       useful for other hard to debug boot hangs as well. Steven?

Actually, I've been thinking about how a such functionality will be
very much useful for tracing other stuff too. Enable tracepoints on the
cmdline and then catch output on serial console. This would be very cool
feature for general debugging too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
