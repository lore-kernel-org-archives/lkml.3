Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3H3Pvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:51:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3H3Pvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:51:45 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDI8IL8UnGoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BKUXQ1-ENX0A:10 a=oGMlB6cnAAAA:8 a=pZp7V2q4PYYelp8t_h4A:9 a=CjuIK1q_8ugA:10 a=CY6gl2JlH4YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 30 Aug 2013 11:51:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled
 DYNAMIC_FTRACE
Message-ID: <20130830115142.1ee4c825@gandalf.local.home>
In-Reply-To: <5220BC1A.3030108@zytor.com>
References: <5217908E.2040702@siemens.com>
	<5220BC1A.3030108@zytor.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013 08:36:58 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/23/2013 09:40 AM, Jan Kiszka wrote:
> > Hi all,
> > 
> > 32-bit kernels currently crash/reboot in early microcode loading when
> > non-dynamic function tracing is enabled. Several functions in that path
> > get instrumented with mcount, but its non-dynamic implementation does
> > not work before paging is enabled (it accesses global variables at wrong
> > addresses).
> > 
> > Below some hunks to get it working again - at least in the absence of
> > any microcode in the initrd. Marking all involved functions as __init is
> > another option (as __init implies notrace). But I bet there is more
> > hidden. I see e.g. a pr_warn() in find_cpio_init that should trigger the
> > issue as well if we hit the error it reports (btw. printing at this
> > point of the boot should not work anyway, should it?).
> > 
> > Better ideas?
> > 
> > Jan
> > 
> 
> A better idea would be for the mcount/__fentry__ function to simply
> return until the function tracing stuff is actually ready.
> 

It does when dynamic tracing is enabled. But this issue is with static
tracing, there's no code modification, thus all functions call
mcount/__fentry__ and we need to look at a variable to determine if we
should trace or not.

-- Steve
