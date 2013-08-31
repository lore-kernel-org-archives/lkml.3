Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3HaFH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:07:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37274 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab3HaFH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:07:28 -0400
Date: Sat, 31 Aug 2013 07:07:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled
 DYNAMIC_FTRACE
Message-ID: <20130831050737.GB12617@x1.alien8.de>
References: <5217908E.2040702@siemens.com>
 <5220BC1A.3030108@zytor.com>
 <20130830115142.1ee4c825@gandalf.local.home>
 <5220C9C6.5020808@zytor.com>
 <20130830130331.1e260e85@gandalf.local.home>
 <52210537.2070805@zytor.com>
 <20130830201741.07fea07f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130830201741.07fea07f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 08:17:41PM -0400, Steven Rostedt wrote:
> On Fri, 30 Aug 2013 13:48:55 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > >> You *could* bail out of the calling address is < PAGE_OFFSET.
> > 
> > Anyway... can we add this to the static tracing code?  It is two
> > instructions and is only needed on x86-32.  For performance, use dynamic.
> 
> Sure, do you want to add it ?

Another, simpler option could be to make static tracing depend on
!MICROCODE until the first has been removed.

-- 
Regards/Gruss,
Boris.
