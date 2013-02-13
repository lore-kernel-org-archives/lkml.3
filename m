Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397Ab3BMRlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:41:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:60477 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759980Ab3BMRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:41:50 -0500
Date: Wed, 13 Feb 2013 18:41:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
In-Reply-To: <1360776274.23152.7.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1302131841340.22263@ionos>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de> <1360776274.23152.7.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, Steven Rostedt wrote:

> On Wed, 2013-02-13 at 17:11 +0100, Sebastian Andrzej Siewior wrote:
> > 3.2-rt is a long term supported kernel, which lacks two RT features
> > from 3.6: SLUB support and the split softirq lock implementation.
> > 
> > SLUB has a way better performance than SLAB on RT and the split
> > softirq lock implementation is necessary especially for realtime
> > networking applications.
> > 
> > The following patch series backports these features to 3.2-rt.
> > 
> > Steven, could you please apply these patches to a separate
> > 3.2-rt-features branch?
> 
> Is it possible to separate these two features into two different patch
> sets. I would like to apply the softirq changes first, and then apply
> the slub changes.
> 
> Although it looks as though the first half is softirq only 1-8, and the
> second half is slub related 9-16. If that's the case, I'll just pull in
> 1-8 first, play with them, and then do 9-16.

That's correct.
