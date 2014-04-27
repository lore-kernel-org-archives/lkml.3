Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaD0Ssz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:48:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:53241 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751897AbaD0Ssy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:48:54 -0400
Date: Sun, 27 Apr 2014 14:48:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] rtmutex: Do not prio boost when timeout is used
Message-ID: <20140427144852.389311e6@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1404271947260.6261@ionos.tec.linutronix.de>
References: <20140425162848.0e1deed8@gandalf.local.home>
	<alpine.DEB.2.02.1404271947260.6261@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glad I put on my shark repellent.

On Sun, 27 Apr 2014 20:20:26 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> We really have better things to do, than changing the rules just to
> please some random (probably commercial) application which has been
> programmed along the coding rules from hell.
> 

Peter had already pointed out that the current behavior is actually
specified by the standards. This patch is thus NULL and void. I only
posted this patch because you haven't bitched at me in a while and I
figured I was due.

I just noticed this when we were trying to debug why an application is
reporting EDEADLOCK on a lock. This was a side discussion as there were
no timeout locks in the application.

It looks more like a bug in the glibc implementation, as they have
both RECURSIVE and PRIO_INHERIT set on the mutex, and it seems that it
is deadlocking on a lock it already owns when it tries to retake it.

-- Steve
