Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaD2OGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:06:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23542 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932647AbaD2OGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:06:54 -0400
Date: Tue, 29 Apr 2014 10:06:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429100652.56c8c07f@gandalf.local.home>
In-Reply-To: <535FA920.9080503@linux.intel.com>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
	<535FA920.9080503@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 06:29:04 -0700
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

 
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

Bad behaving BIOS? But I'm sure there's no such thing ;-)

-- Steve

