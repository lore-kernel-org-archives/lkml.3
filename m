Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3HFRsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:48:53 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36424 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3HFRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <1375798783.25420.30.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	<1375727977.22073.112.camel@gandalf.local.home>
	<CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	<1375798783.25420.30.camel@gandalf.local.home>
Date: Tue, 6 Aug 2013 10:48:51 -0700
X-Google-Sender-Auth: 8oAFBhNYCcTT5hQxhPVcHwDQ_Zw
Message-ID: <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> After playing with the patches again, I now understand why I did that.
> It wasn't just for optimization.

[explanation snipped]

> Anyway, if you feel that update_jump_label is too complex, I can go the
> "update at early boot" route and see how that goes.

Ugh. I'd love to see short jumps, but I do dislike binary rewriting,
and doing it at early boot seems really quite scary too.

So I wonder if this is a "ok, let's not bother, it's not worth the
pain" issue. 128 bytes of offset is very small, so there probably
aren't all that many cases that would use it.

                 Linus
