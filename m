Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3HEUCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:02:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21961 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3HEUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:02:07 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=7d_E57ReAAAA:8 a=w5TYOFXWuOMd9YdAKMIA:9 a=QEXdDO2ut3YA:10 a=D6-X0JM3zdQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375732925.22073.150.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 05 Aug 2013 16:02:05 -0400
In-Reply-To: <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com>
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
	 <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 12:57 -0700, Linus Torvalds wrote:
> On Mon, Aug 5, 2013 at 12:54 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > I remember that choosing between 2 and 5 bytes nop in the asm goto was
> > tricky: it had something to do with the fact that gcc doesn't know the
> > exact size of each instructions until further down within compilation
> 
> Oh, you can't do it in the coompiler, no. But you don't need to. The
> assembler will pick the right version if you just do "jmp target".

Right, and that's exactly what my patches did.

-- Steve


