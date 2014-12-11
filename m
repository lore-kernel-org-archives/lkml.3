Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbaLKF3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:29:42 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47463 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaLKF3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:29:41 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwUrFysQU1y-r_jWtA=NuXaNA06UYT-bF_hvA7mexj4=g@mail.gmail.com>
References: <20141208100528.5f97106f@gandalf.local.home>
	<20141208100851.3906cc0a@gandalf.local.home>
	<CA+55aFwUrFysQU1y-r_jWtA=NuXaNA06UYT-bF_hvA7mexj4=g@mail.gmail.com>
Date: Wed, 10 Dec 2014 21:29:40 -0800
X-Google-Sender-Auth: TSZIReKRf5apnMPRc6foJh8h0-o
Message-ID: <CA+55aFz5-_LKW4JHEBoWinN9_ouNcGRWAF2FUA35u46FRN-Kxw@mail.gmail.com>
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

On Wed, Dec 10, 2014 at 8:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Would it perhaps be possible/reasonable to also use this to get rid of
> the horrible "early_printk()" stuff [...]

Another question: the "preempt_disable/enable()" around the use of the
per-cpu vprintk_func thing seems dubious.

Why do I say that? I think it cannot possibly make sense. Anybody who
sets that function pointer to any per-cpu value has to disable
preemption for that to make sense, so doing it inside the printk()
paths seems dubious at best.

No?

                    Linus
