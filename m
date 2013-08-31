Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3HaFXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:23:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3HaFXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:23:30 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDI8IL8UnGoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BKUXQ1-ENX0A:10 a=oGMlB6cnAAAA:8 a=lymH9lD9naPdF7IIVwwA:9 a=CjuIK1q_8ugA:10 a=1JvJEtVdGvUA:10 a=CY6gl2JlH4YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Sat, 31 Aug 2013 01:23:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled
 DYNAMIC_FTRACE
Message-ID: <20130831012327.22813171@gandalf.local.home>
In-Reply-To: <20130831050737.GB12617@x1.alien8.de>
References: <5217908E.2040702@siemens.com>
	<5220BC1A.3030108@zytor.com>
	<20130830115142.1ee4c825@gandalf.local.home>
	<5220C9C6.5020808@zytor.com>
	<20130830130331.1e260e85@gandalf.local.home>
	<52210537.2070805@zytor.com>
	<20130830201741.07fea07f@gandalf.local.home>
	<20130831050737.GB12617@x1.alien8.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 07:07:37 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Aug 30, 2013 at 08:17:41PM -0400, Steven Rostedt wrote:
> > On Fri, 30 Aug 2013 13:48:55 -0700
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> > > >> You *could* bail out of the calling address is < PAGE_OFFSET.
> > > 
> > > Anyway... can we add this to the static tracing code?  It is two
> > > instructions and is only needed on x86-32.  For performance, use dynamic.
> > 
> > Sure, do you want to add it ?
> 
> Another, simpler option could be to make static tracing depend on
> !MICROCODE until the first has been removed.
> 

Might be trickier than you think. Static tracing is the default.
Dynamic tracing is the extension. By making static tracing depend
on !MICROCODE, you basically made function tracing depend on !MICROCODE.

I guess you could make MICROCODE select DYNAMIC_FTRACE, but that could
get messy.

-- Steve
