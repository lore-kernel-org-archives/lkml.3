Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3DZIlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:41:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:47649 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3DZIll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:41:41 -0400
Date: Fri, 26 Apr 2013 10:41:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
Message-ID: <20130426084137.GC20927@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365705214.9609.58.camel@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-04-11 14:33:34 [-0400]:

>As wait queue locks are notorious for long hold times, we can not
>convert them to raw_spin_locks without causing issues with -rt. But
>Thomas has created a "simple-wait" structure that uses raw spin locks
>which may have been a good fit.
>
>Unfortunately, wait queues are not the only issue, as the mce_notify_irq
>also does a schedule_work(), which grabs the workqueue spin locks that
>have the exact same issue.

mce_notify_irq() can use simple_waitqueue, no?
The other issue is that mce_report_event() is scheduling a per-cpu
workqueue (mce_schedule_work) in case of a memory fault. This has the
same issue.

Sebastian
