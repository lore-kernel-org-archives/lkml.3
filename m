Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaEGOfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:35:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25801 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759AbaEGOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:35:14 -0400
Date: Wed, 7 May 2014 10:35:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
Message-ID: <20140507103512.5b3f7928@gandalf.local.home>
In-Reply-To: <CALZtONBADrb_yCPqCAUfw1ei9sYxw_-MopPko3dcfas2mqsVZg@mail.gmail.com>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	<1399300985-11137-1-git-send-email-ddstreet@ieee.org>
	<20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
	<CALZtONAVTQuOF3ddZ6jVZqCGgKBicAtT=_w5w4GEueYAsf3jtw@mail.gmail.com>
	<20140506174445.b64dffb78d0676b48fa68eea@skynet.be>
	<CALZtONBADrb_yCPqCAUfw1ei9sYxw_-MopPko3dcfas2mqsVZg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 10:21:28 -0400
Dan Streetman <ddstreet@ieee.org> wrote:


> It would be even better if the note could clarify that sometimes it is
> ok to use printk(KERN_DEBUG

Exactly. I think it's rather stupid to have to do a #define DEBUG to
have pr_debug() print in general.

I see no reason to have pr_debug() be anything different than the other
pr_*() functions. Perhaps the pr_debug() should have been called
debug_print(), or dyn_print(), where it can be dynamic printk or
enabled with a DEBUG macro.

The plist code is a perfect scenario where printk(KERN_DEBUG...) is
appropriate, and using pr_debug() with a hard coded #define DEBUG is
just stupid.

-- Steve
