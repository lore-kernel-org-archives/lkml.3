Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100AbaD3WLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:11:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaD3WLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:11:02 -0400
Date: Thu, 1 May 2014 00:10:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
In-Reply-To: <535FA920.9080503@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1405010008420.10908@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz> <535FA920.9080503@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, H. Peter Anvin wrote:

> > [2] 	"A special case can occur if an SMI handler nests inside an NMI 
> > 	 handler and then another NMI occurs. During NMI interrupt 
> > 	 handling, NMI interrupts are disabled, so normally NMI interrupts 
> >  	 are serviced and completed with an IRET instruction one at a 
> > 	 time. When the processor enters SMM while executing an NMI 
> > 	 handler, the processor saves the SMRAM state save map but does 
> > 	 not save the attribute to keep NMI interrupts disabled. 
> > 	 Potentially, an NMI could be latched (while in SMM or upon exit) 
> > 	 and serviced upon exit of SMM even though the previous NMI  
> > 	 handler has still not completed."
> 
> I believe [2] only applies if there is an IRET executing inside the SMM
> handler, which should not normally be the case.  It might also have been
> addressed since that was written, but I don't know.

Is there any chance that Intel would reveal what's behind this paragraph 
and how likely it is to expect such BIOSes in the wild?

Thanks,

-- 
Jiri Kosina
SUSE Labs
