Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaLKEUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:20:37 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60487 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaLKEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141208100851.3906cc0a@gandalf.local.home>
References: <20141208100528.5f97106f@gandalf.local.home>
	<20141208100851.3906cc0a@gandalf.local.home>
Date: Wed, 10 Dec 2014 20:20:35 -0800
X-Google-Sender-Auth: kMYPwLNghjc6DO9kkEWImnkzxq0
Message-ID: <CA+55aFwUrFysQU1y-r_jWtA=NuXaNA06UYT-bF_hvA7mexj4=g@mail.gmail.com>
Subject: Re: [GIT PULL] tracing/NMI/printk: Use seq_buf for safe printing from
 NMI context
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 7:08 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> One added bonus is that this code also makes the NMI dump stack work on
> PREEMPT_RT kernels. As printk() includes sleeping locks on PREEMPT_RT,
> printk() only writes to console if the console does not use any
> rt_mutex converted spin locks. Which a lot do.

Would it perhaps be possible/reasonable to also use this to get rid of
the horrible "early_printk()" stuff, and switch to "vprintk_default"
only once the system is sufficiently up-and-running?

Hmm? Not that there are very many users of that horrible thing.

                   Linus
