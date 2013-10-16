Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab3JPT5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:57:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:3213 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760584Ab3JPT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:57:35 -0400
Date: Wed, 16 Oct 2013 15:57:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016155730.7fd55ac5@gandalf.local.home>
In-Reply-To: <20131016193632.GH4553@linux.vnet.ibm.com>
References: <20131015163906.342d8ffa@gandalf.local.home>
	<20131016114036.GB12773@localhost.localdomain>
	<20131016084518.44eaf61a@gandalf.local.home>
	<20131016130856.GE12773@localhost.localdomain>
	<20131016193632.GH4553@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 12:36:32 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> > Ah but we have an in_interrupt() check in context_tracking_user_enter() that protects
> > us against that.
> 
> Here you are relying on the exception being treated as an interrupt,
> correct?

I don't think so. It's relying on nmi_enter() also makes in_interrupt()
return true.

Like I said before. An NMI interrupting userspace should be no
different than an interrupt interrupting userspace. They both can
trigger vmalloc faults, and we should be able to deal with it.

-- Steve
