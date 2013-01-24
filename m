Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3AXIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:51:17 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:46411 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3AXIvG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 24 Jan 2013 03:51:06 -0500
Message-Id: <5101040702000078000B9007@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 24 Jan 2013 08:51:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Salman Qazi" <sqazi@google.com>, "Ingo Molnar" <mingo@kernel.org>,
        "ThomasGleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][GIT PULL][3.8] x86: Don't clobber top of pt_regs
 in nested NMI
References: <1351883953.4004.144.camel@gandalf.local.home>
 <50978DC902000078000A64AB@nat28.tlf.novell.com>
 <1358971252.21576.121.camel@gandalf.local.home>
In-Reply-To: <1358971252.21576.121.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.01.13 at 21:00, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-11-05 at 08:58 +0000, Jan Beulich wrote:
>> >>> On 02.11.12 at 20:19, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > @@ -1842,8 +1851,12 @@ nmi_swapgs:
>> >  	SWAPGS_UNSAFE_STACK
>> >  nmi_restore:
>> >  	RESTORE_ALL 8
>> > +
>> > +	/* Pop the extra iret frame */
>> > +	addq $(5*8), %rsp
>> 
>> This could (for code efficiency) and should (for CFI annotation
>> correctness) be folded into the RESTORE_ALL above (by
>> converting "8" to "6*8").
> 
> This change never made it in. Would you like to send a patch, or would
> you want me to do it?

Let me do so - I have a patch pending for the CFI part of this
already, and simply forgot that folding the two operations would
be the simpler solution to the issue.

Jan

