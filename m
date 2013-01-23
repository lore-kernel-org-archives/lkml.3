Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3AWUBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:01:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3AWUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:00:55 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qt19TlZbzfwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=StY-X9Ple9EA:10 a=uNFOcSXsGN843nhkPjoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358971252.21576.121.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL][3.8] x86: Don't clobber top of pt_regs in
 nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 15:00:52 -0500
In-Reply-To: <50978DC902000078000A64AB@nat28.tlf.novell.com>
References: <1351883953.4004.144.camel@gandalf.local.home>
	 <50978DC902000078000A64AB@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 08:58 +0000, Jan Beulich wrote:
> >>> On 02.11.12 at 20:19, Steven Rostedt <rostedt@goodmis.org> wrote:
> > @@ -1842,8 +1851,12 @@ nmi_swapgs:
> >  	SWAPGS_UNSAFE_STACK
> >  nmi_restore:
> >  	RESTORE_ALL 8
> > +
> > +	/* Pop the extra iret frame */
> > +	addq $(5*8), %rsp
> 
> This could (for code efficiency) and should (for CFI annotation
> correctness) be folded into the RESTORE_ALL above (by
> converting "8" to "6*8").

Hi Jan,

This change never made it in. Would you like to send a patch, or would
you want me to do it?

-- Steve

> 
> Jan
> 
> > +
> >  	/* Clear the NMI executing stack variable */
> > -	movq $0, 10*8(%rsp)
> > +	movq $0, 5*8(%rsp)
> >  	jmp irq_return
> >  	CFI_ENDPROC
> >  END(nmi)
> 


