Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3AaVVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:21:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AaVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:21:20 -0500
Date: Thu, 31 Jan 2013 13:21:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130131132118.6c4a484a.akpm@linux-foundation.org>
In-Reply-To: <CAK7N6vptwoT+D4=Qs6D0a-vB8DbcHya_taJ6s7JxG7gQxEfwtw@mail.gmail.com>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
	<20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
	<20130116145005.e20f4e53.akpm@linux-foundation.org>
	<20130116235529.GA10251@quack.suse.cz>
	<20130116161118.f6e2e6a4.akpm@linux-foundation.org>
	<20130117210442.GA23984@quack.suse.cz>
	<20130117133917.0f75728e.akpm@linux-foundation.org>
	<CAK7N6vptwoT+D4=Qs6D0a-vB8DbcHya_taJ6s7JxG7gQxEfwtw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 13:14:05 +0530
anish singh <anish198519851985@gmail.com> wrote:

> > If it does need ratelimiting, I'd worry about using jiffies for that.
> > If the kernel is spending a long time with interrupts disabled, jiffies
> > might not be incrementing.  Using the CPU timestamp would be better
> > (eg, sched_clock()).
> 
> http://lxr.free-electrons.com/source/kernel/sched/clock.c#L75
> I am puzzled because of this definition(above link).Sched_clock is
> dependent on jiffies and jiffies is blocked so how sched_clock would
> be better(I am 100% missing something very obvious)?
> 
> Is it that sched_clock is not dependent on jiffies?

yes, I think sched_clock is dependent on jiffies for some architectures.

I was really using sched_clock as a place-filler for "some timer which
keeps running when interrupts are disabled" ;) I'm not really sure what
that would be nowadays - even get_cycles() isn't implemented on some
architectures.  I guess some architectures will need a lame fallback or
some sort.


