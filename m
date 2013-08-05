Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab3HESt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:49:58 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63464 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3HESt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <1375727977.22073.112.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	<1375727977.22073.112.camel@gandalf.local.home>
Date: Mon, 5 Aug 2013 11:49:56 -0700
X-Google-Sender-Auth: HtCcPvgK2Ts2V9ztOFQG9Zy8Il0
Message-ID: <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
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

On Mon, Aug 5, 2013 at 11:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I had patches that did exactly this:
>
>  https://lkml.org/lkml/2012/3/8/461
>
> But it got dropped for some reason. I don't remember why. Maybe because
> of the complexity?

Ugh. Why the crazy update_jump_label script stuff? I'd go "Eww" at
that too, it looks crazy. The assembler already knows to make short
2-byte "jmp" instructions for near jumps, and you can just look at the
opcode itself to determine size, why is all that other stuff required?

IOW, 5/7 looks sane, but 4/7 makes me go "there's something wrong with
that series".

                 Linus
