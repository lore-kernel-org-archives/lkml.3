Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3EARXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:23:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3EARXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:23:41 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FyKHsfsonOgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=9dsyo4kK9RUA:10 a=otb9mOhbaC6PdNlQ0dMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367429019.30667.94.camel@gandalf.local.home>
Subject: Re: [PATCH] init: Do not warn on non-zero initcall return
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 01 May 2013 13:23:39 -0400
In-Reply-To: <CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com>
References: <1367420537.30667.91.camel@gandalf.local.home>
	 <CA+55aFzaBC5SFi7=F2mfm+KWY5qTsBmOqgbbs8E+LUS8JK-sBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 10:11 -0700, Linus Torvalds wrote:
> On Wed, May 1, 2013 at 8:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Commit f91eb62f71 "init: scream bloody murder if interrupts are enabled
> > too early" added three new warnings. The first two seemed reasonable,
> > but the third included a warning when an initcall returned non-zero.
> > Although, the third WARN() does include an imbalanced preempt disabled,
> > or irqs disable, it shouldn't warn if it only had an initcall that just
> > returns non-zero.
> 
> Ugh. Sorry, but this patch just looks stupid.
> 
> It seems that the right thing to do is to just remove the whole crappy
> 
>         if (ret && ret != -ENODEV && initcall_debug)
>                 sprintf(msgbuf, "error code %d ", ret);
> 
> thing entirely, since it's moronic to add that error code printout
> anyway, since if initcall_debug is set, we already do a much *better*
> job earlier with the whole
> 
>         pr_debug("initcall %pF returned %d after %lld usecs\n",
>                  fn, ret, duration);
> 
> printout in do_one_initcall_debug().  That will then fix the WARN()
> issue automatically.

Heh, I didn't even notice that it only prints if initcall_debug was
enabled.

OK, I'll just remove that part of the code.

-- Steve


