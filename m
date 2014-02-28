Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaB1VBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:01:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:53398 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814AbaB1VBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:01:45 -0500
Date: Fri, 28 Feb 2014 16:01:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86: Rename copy_from_user_nmi() to
 copy_from_user_trace()
Message-ID: <20140228160139.3762b511@gandalf.local.home>
In-Reply-To: <20140228204621.GA14089@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
	<20140228154026.GH9987@twins.programming.kicks-ass.net>
	<5310B60F.30806@zytor.com>
	<20140228112946.1f194397@gandalf.local.home>
	<20140228143316.211d4034@gandalf.local.home>
	<20140228204621.GA14089@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 21:46:21 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> NAK, spin_lock_irq() is very much an IRQ safe lock. Similarly

Actually, that's not true. It doesn't mean it is an IRQ safe lock. That
would mean it is safe to use in IRQs. What it does mean is that it
disables irqs and spin_unlock_irq() enables irqs. And we have
spin_lock_irqsave() which disables irqs and saves the flags for a
spin_lock_irqrestore()

> copy_from_user_nmi() is an NMI safe copy from user.
> 
> Furthermore, there's exactly 0 trace users, so the proposed name is
> actively worse.

OK, I'll go with that. So instead of an _nmi() which it has nothing to
do with NMIs, how about making it like spin_lock_irq() and a more
descriptive name about what it does?

 copy_from_user_savecr2()

?

-- Steve

