Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbaKSWOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:14:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:47836 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbaKSWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:13:59 -0500
Date: Wed, 19 Nov 2014 23:13:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86, syscall: Fix _TIF_NOHZ handling in
 syscall_trace_enter_phase1
In-Reply-To: <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1411192311560.3909@nanos>
References: <546D0530.8040800@mit.edu> <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Andy Lutomirski wrote:

> TIF_NOHZ is 19 (i.e. _TIF_SYSCALL_TRACE | _TIF_NOTIFY_RESUME |
> _TIF_SINGLESTEP), not (1<<19).
> 
> This code is involved in Dave's trinity lockup, but I don't see why
> it would cause any of the problems he's seeing, except inadvertently
> by causing a different path through entry_64.S's syscall handling.

Right, while it is wrong it does not explain the wreckage on 3.17,
which does not have that code.

Thanks,

	tglx
