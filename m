Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3FDSRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:17:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36636 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3FDSRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:17:32 -0400
Message-ID: <51AE2EDF.3000505@zytor.com>
Date: Tue, 04 Jun 2013 11:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: Re: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com> <1370303581.26799.109.camel@gandalf.local.home>
In-Reply-To: <1370303581.26799.109.camel@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 04:53 PM, Steven Rostedt wrote:
> 
> This way we wont be opening up any easy root holes where if a process
> finds a way to modify some arbitrary kernel memory, we can prevent it
> from modifying the current_idt_descr_ptr and have a nice way to exploit
> the IDT. Sure, one can argue that if they can modify arbitrary kernel
> memory, we may already be lost, but lets not make it easier for them
> than need be.
> 

I don't like current_idt_descr_ptr if we can avoid it.  It is a direct
proxy for reading and writing the original IDT, in other words, it
really hasn't really addressed the issue.

What I'm thinking we really should have is a function that returns the
IDT that we currently should be using, based on the current state.  If
that state is, say, tracing on/off and NMI on/off, then that can be
indicated by bits in a state vector.

The point is that the IDT address itself should not be mutable state if
it can be at all avoided.

	-hpa



