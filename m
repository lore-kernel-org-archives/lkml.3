Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3K2NoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:44:14 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:58802 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3K2NoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:44:10 -0500
Date: Fri, 29 Nov 2013 08:44:06 -0500
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131129134406.GA3717@htj.dyndns.org>
References: <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128142359.GA6420@redhat.com>
 <20131128143155.GC3925@htj.dyndns.org>
 <20131128150055.GA11956@redhat.com>
 <20131128150233.GA10022@twins.programming.kicks-ass.net>
 <20131128193330.GA24767@redhat.com>
 <20131128193349.GB24767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128193349.GB24767@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Thu, Nov 28, 2013 at 08:33:49PM +0100, Oleg Nesterov wrote:
> @@ -208,13 +208,9 @@ static int ____call_usermodehelper(void *data)
>  	spin_lock_irq(&current->sighand->siglock);
>  	flush_signal_handlers(current, 1);
>  	spin_unlock_irq(&current->sighand->siglock);
> -
> -	/* We can run anywhere, unlike our parent keventd(). */
> -	set_cpus_allowed_ptr(current, cpu_all_mask);

I don't think this is correct on numa machines where unbound workers
are NUMA-node affine by default.

Thanks.

-- 
tejun
