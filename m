Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbaLKTlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:41:24 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:38481 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbaLKTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141211063307.6f429b78@gandalf.local.home>
References: <20141208100528.5f97106f@gandalf.local.home>
	<20141208100851.3906cc0a@gandalf.local.home>
	<CA+55aFwUrFysQU1y-r_jWtA=NuXaNA06UYT-bF_hvA7mexj4=g@mail.gmail.com>
	<CA+55aFz5-_LKW4JHEBoWinN9_ouNcGRWAF2FUA35u46FRN-Kxw@mail.gmail.com>
	<20141211063307.6f429b78@gandalf.local.home>
Date: Thu, 11 Dec 2014 11:41:21 -0800
X-Google-Sender-Auth: YtfpXivllkarCyj5OD7Un5iMz9s
Message-ID: <CA+55aFxKSzUU7EMDyV9voi0MjzE+2AFeT8t_Fs=dUV2f5rndvw@mail.gmail.com>
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

On Thu, Dec 11, 2014 at 3:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> So you are saying that anytime the printk_func is not the default, the
> caller had to have disable preemption?

Yes. That, or change all of the vprintk_func entries. Otherwise, the
caller itself obviously doesn't know which cpu version it would get,
so disabling preemption inside printk is simply much too late.

                     Linus
