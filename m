Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3HET5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:57:48 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57216 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3HET5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130805195446.GA22359@Krystal>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<51FFEC56.6040206@linux.intel.com>
	<1375727010.22073.110.camel@gandalf.local.home>
	<51FFEEEC.5060902@linux.intel.com>
	<1375728583.22073.118.camel@gandalf.local.home>
	<51FFF430.1060701@linux.intel.com>
	<CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>
	<20130805195446.GA22359@Krystal>
Date: Mon, 5 Aug 2013 12:57:46 -0700
X-Google-Sender-Auth: oawmeBo-yXBa2onN_GdmOOGG_h4
Message-ID: <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:54 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> I remember that choosing between 2 and 5 bytes nop in the asm goto was
> tricky: it had something to do with the fact that gcc doesn't know the
> exact size of each instructions until further down within compilation

Oh, you can't do it in the coompiler, no. But you don't need to. The
assembler will pick the right version if you just do "jmp target".

             Linus
