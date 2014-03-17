Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaCQXSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:18:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaCQXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:18:50 -0400
Date: Mon, 17 Mar 2014 23:18:14 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        penguin-kernel@I-love.SAKURA.ne.jp, Oleg Nesterov <oleg@redhat.com>,
        rientjes@google.com, Linus Torvalds <torvalds@linux-foundation.org>,
        tj@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
 killable
Message-ID: <20140317231814.3249e6d2@alan.etchedpixels.co.uk>
In-Reply-To: <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
References: <53236AA2.7030105@canonical.com>
	<20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Root cause time: it's wrong for the oom-killer to use SIGKILL.  In fact

It has to use SIGKILL anything else might be caught and grow the user
stack a page..

> it's basically always wrong to send signals from in-kernel.  Signals
> are a userspace IPC mechanism and using them in-kernel a) makes it hard
> (or impossible) to distinguish them from userspace-originated signals

Actually signals are a kernel messaging system someone repurposed for IPC.

> and b) permits userspace to produce surprising results in the kernel,
> which I suspect is what we're seeing here.

There is enough information for kernel side code to decide whether a
signal came from kernel or userspace. Then again - it's not clear that it
should ever have to.

Alan
