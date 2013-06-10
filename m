Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab3FJOQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:16:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:56657 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3FJOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:16:45 -0400
Date: Mon, 10 Jun 2013 16:15:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/softirq.c: delete 'while' looping to improve a
 little performance and beautify code
In-Reply-To: <51B4755B.4020205@asianux.com>
Message-ID: <alpine.LFD.2.02.1306101613200.22970@ionos>
References: <51B4755B.4020205@asianux.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Jun 2013, Chen Gang wrote:
> After finish the internal 'while', need not test TASKLET_STATE_SCHED
> again, so looping back to outside 'while' is only for set_bit().
> 
> When use 'if' and set_bit() instead of 'while', it will save at least
> one running conditional instruction, and also will be clearer for readers
> (although the binary size will be a little bigger).

And by doing that you break the atomicity of test_and_set_bit. There
is a good reason why this is an atomic operation and why the code is
written as is.
 
> The related patch is "1da177e Linux-2.6.12-rc2"

How is that patch related to the problem?

Thanks

	tglx
