Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3H3RDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:03:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3H3RDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:03:33 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDI8IL8UnGoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BKUXQ1-ENX0A:10 a=oGMlB6cnAAAA:8 a=xtpnuDK__jDR5YpMp14A:9 a=CjuIK1q_8ugA:10 a=CY6gl2JlH4YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 30 Aug 2013 13:03:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled
 DYNAMIC_FTRACE
Message-ID: <20130830130331.1e260e85@gandalf.local.home>
In-Reply-To: <5220C9C6.5020808@zytor.com>
References: <5217908E.2040702@siemens.com>
	<5220BC1A.3030108@zytor.com>
	<20130830115142.1ee4c825@gandalf.local.home>
	<5220C9C6.5020808@zytor.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013 09:35:18 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/30/2013 08:51 AM, Steven Rostedt wrote:
> > 
> > It does when dynamic tracing is enabled. But this issue is with static
> > tracing, there's no code modification, thus all functions call
> > mcount/__fentry__ and we need to look at a variable to determine if we
> > should trace or not.
> > 
> 
> And of course global variables are a no-no without special handling in
> pre-paging mode.  Sigh.
> 
> You *could* bail out of the calling address is < PAGE_OFFSET.
> 

We could do that too, as static tracing already gives us high overhead,
I'm not sure how much more overhead another check like this even
matters.

Who uses static tracing? I only use it to test that it still works ;-)

-- Steve
