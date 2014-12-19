Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaLSAfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:35:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:60789 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLSAfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:35:05 -0500
Date: Fri, 19 Dec 2014 01:34:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shaohua Li <shli@fb.com>
cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to
 vDSO
In-Reply-To: <20141219003044.GA2804333@devbig257.prn2.facebook.com>
Message-ID: <alpine.DEB.2.11.1412190131500.17382@nanos>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com> <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com> <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com> <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219003044.GA2804333@devbig257.prn2.facebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Shaohua Li wrote:
> On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> > Bad news: this patch is incorrect, I think.  Take a look at
> > update_rq_clock -- it does fancy things involving irq time and
> > paravirt steal time.  So this patch could result in extremely
> > non-monotonic results.
> 
> Yes, it's not precise. But bear in mind, CONFIG_IRQ_TIME_ACCOUNTING is a
> optional feature. Actually it's added not long time ago. I thought it's
> acceptable the time isn't precise just like what we have before the
> feature is added.

Wrong thought, really.

If the vdso can give you observable inconsistent representation
vs. real syscalls then it does not matter at all how long ago the
feature was added. It's simply wrong no matter what.

Thanks,

	tglx
