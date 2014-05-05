Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaEEUfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:35:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaEEUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:35:19 -0400
Date: Mon, 5 May 2014 13:35:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Fabian Frederick <fabf@skynet.be>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
Message-Id: <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
In-Reply-To: <1399300985-11137-1-git-send-email-ddstreet@ieee.org>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	<1399300985-11137-1-git-send-email-ddstreet@ieee.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 May 2014 10:43:05 -0400 Dan Streetman <ddstreet@ieee.org> wrote:

> Replace pr_debug() in lib/plist.c test function plist_test() with
> printk(KERN_DEBUG ...).
> 
> Without DEBUG defined, pr_debug() is complied out, but the entire
> plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
> printk should just be used directly.
>
> --- a/lib/plist.c
> +++ b/lib/plist.c
> @@ -175,7 +175,7 @@ static int  __init plist_test(void)
>  	int nr_expect = 0, i, loop;
>  	unsigned int r = local_clock();
>  
> -	pr_debug("start plist test\n");
> +	printk(KERN_DEBUG "start plist test\n");

Now someone will come along and helpfully switch it back to pr_debug()
again :(

What about adding a #define DEBUG?



This aspect of pr_debug() is rather surprising and unfortunate and I
guess we screwed it up.  pr_debug() should unconditionally do the
printk, just like pr_warn, pr_emerg, etc.  And there should be a
separate pr_debug_cond() which honours the DEBUG setting.

akpm3:/usr/src/linux-3.15-rc4> grep -r pr_debug . | wc -l
10286

Boy, that's going to be a big patch ;)
