Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3HFQ04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:26:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3HFQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:26:54 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=W3ig_ibawsWDzsg6NO8A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375806413.25420.36.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 06 Aug 2013 12:26:53 -0400
In-Reply-To: <52012229.2020707@linux.intel.com>
References: <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	  <1375725328.22073.101.camel@gandalf.local.home>
	  <51FFEC56.6040206@linux.intel.com>
	  <1375727010.22073.110.camel@gandalf.local.home>
	  <51FFEEEC.5060902@linux.intel.com>
	  <1375728583.22073.118.camel@gandalf.local.home>
	  <51FFF430.1060701@linux.intel.com>
	  <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>
	  <20130805195446.GA22359@Krystal>
	  <CA+55aFwrxRr4+kN8t8HCRnnVQyur5EGzQ_bRdYK3T-KW9Zp0aw@mail.gmail.com>
	  <20130805212855.GA23044@Krystal> <52001C92.3070209@linux.intel.com>
	 <1375805711.25420.34.camel@gandalf.local.home>
	 <52012229.2020707@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 09:19 -0700, H. Peter Anvin wrote:
> On 08/06/2013 09:15 AM, Steven Rostedt wrote:
> > On Mon, 2013-08-05 at 14:43 -0700, H. Peter Anvin wrote:
> > 
> >> For unconditional jmp that should be pretty safe barring any fundamental
> >> changes to the instruction set, in which case we can enable it as
> >> needed, but for extra robustness it probably should skip prefix bytes.
> > 
> > Would the assembler add prefix bytes to:
> > 
> > 	jmp 1f
> > 
> 
> No, but if we ever end up doing MPX in the kernel, for example, we would
> have to put an MPX prefix on the jmp.

Well then we just have to update the rest of the jump label code :-)

-- Steve


