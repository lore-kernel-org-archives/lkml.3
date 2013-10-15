Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3JOVM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:12:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:63701 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab3JOVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:12:56 -0400
Date: Tue, 15 Oct 2013 23:12:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
Message-ID: <20131015211251.GE3269@localhost.localdomain>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
 <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
 <1381870805.22110.37.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381870805.22110.37.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:00:05PM -0700, Joe Perches wrote:
> On Tue, 2013-10-15 at 22:50 +0200, Frederic Weisbecker wrote:
> []
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> []
> > @@ -252,14 +253,7 @@ extern asmlinkage void dump_stack(void) __cold;
> >  
> >  #ifdef CONFIG_PRINTK
> >  #define printk_once(fmt, ...)			\
> > -({						\
> > -	static bool __print_once;		\
> > -						\
> > -	if (!__print_once) {			\
> > -		__print_once = true;		\
> > -		printk(fmt, ##__VA_ARGS__);	\
> > -	}					\
> > -})
> > +	DO_ONCE(printk(fmt, ##__VA_ARGS__));
> 
> It's hard to believe the overhead is worth it.

Which overhead?
