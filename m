Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900Ab3ECJbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:31:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:44197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3ECJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:31:46 -0400
Message-ID: <518383FB.8020004@linutronix.de>
Date: Fri, 03 May 2013 11:31:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for PREEMPT_RT
References: <1365705214.9609.58.camel@gandalf.local.home>  <20130426084137.GC20927@linutronix.de> <1367505199.30667.132.camel@gandalf.local.home>
In-Reply-To: <1367505199.30667.132.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 04:33 PM, Steven Rostedt wrote:
>> mce_notify_irq() can use simple_waitqueue, no?
> 
> Yeah, and I went down that path.
> 
> But it also schedules work, which has the issue.

Hmm, okay.

>> The other issue is that mce_report_event() is scheduling a per-cpu
>> workqueue (mce_schedule_work) in case of a memory fault. This has the
>> same issue.
> 
> Yeah, that looks like it can be an issue too. I wonder if we can use the
> same thread and use flags check what to do. Atomically set the flag for
> the function to perform, and then have the thread clear it before doing
> the function and only go to sleep when all flags are cleared.

This should work. It uses per-cpu workthreads, not sure why. Maybe to
avoid locking issues when invoked from NMI.

> 
> -- Steve

Sebastian
