Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbbAOOE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:04:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:52101 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbbAOOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:04:26 -0500
Date: Thu, 15 Jan 2015 09:04:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ftrace: Check both notrace and filter for old hash
Message-ID: <20150115090448.717ae011@grimm.local.home>
In-Reply-To: <54B79D98.6070800@hitachi.com>
References: <20150114153958.931152836@goodmis.org>
	<20150114154329.358378039@goodmis.org>
	<54B79D98.6070800@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 19:59:36 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > @@ -3637,6 +3639,7 @@ int
> >  register_ftrace_function_probe(char *glob, struct ftrace_probe_ops
> > *ops, void *data)
> >  {
> > +	struct ftrace_ops_hash old_hash_ops;
> 
> Would it be better to be old_ops_hash? since it's not an ops.

Probably. I'll fix it for 3.20. I ran this through 9 hours of testing
and I don't want to change anything unless I need to (if something else
needs to change, I'll make this fix). Even a comment fix needs to go
through my testing before I send to Linus (I was burnt by a comment
fix that wasn't tested a long time ago, you never know what you might
accidentally change).

> 
> Other parts are OK for me :)
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Thanks!

-- Steve
