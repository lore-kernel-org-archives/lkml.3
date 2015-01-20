Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbbATEFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:05:41 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:44406 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbATEFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:05:40 -0500
Date: Tue, 20 Jan 2015 04:05:37 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86: drop support for 1995 era EISA based
 platforms
In-Reply-To: <1421723901-32303-4-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.LFD.2.11.1501200350230.28301@eddie.linux-mips.org>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com> <1421723901-32303-4-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Paul Gortmaker wrote:

> The Kconfig text says it all, with "The EISA bus saw limited use
> between 1988 and 1995 when it was made obsolete by the PCI bus."
> 
> That means typically 486/586 CPUs in the 33-166MHz range, and
> 8-64MB of installed RAM in typical EISA machines of that era.
> With the additional cost, they were also typically rare, and not
> getting widescale deployment.
> 
> Given that it is 20 years on since its demise, and the above specs
> might seem just barely acceptable for a wireless router today, lets
> stop forcing everyone to build EISA infrastructure and assoc. drivers
> during their routine build coverage testing for no value whatsoever.
> 
> We'd already removed some obsolete 10Mbit EISA network drivers in
> commit bca94cffabf5c9f2399da34eab00bd534bf3735b ("drivers/net: delete
> 8390 based EISA drivers") over two years ago for the same reason.
> 
> If we don't immediately expire EISA completely, we can at least limit
> its impact and support/testing overhead to the arch like alpha and
> parisc that are essentially frozen in time from a hardware perspective.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

 Well, I'd like to keep my x86 box up and alive, to support EISA FDDI 
equipment I maintain if nothing else -- which in particular means the 
current head version of Linux, not some ancient branch.

 Is the maintenance overhead for this stuff really that high?  The amount 
of code you're dropping here does not really impress me.  And it's almost 
exclusively APIC stuff that's straightforward and I can probably give it 
some attention too -- as you may have been aware I have some experience in 
this area, especially where older hardware is concerned.  Unfortunately my 
EISA box is UP, so I can't offer run-time validation for APIC/SMP code at 
the moment, but as I say, this is really plain stuff.

 I don't require that everyone around the planet validates EISA support of 
course -- if that is what really concerns you (quite validly, IMHO), then 
how about a configuration option instead to annotate more exotic stuff 
with, so that people who have, say, commercial interest in Linux only, can 
tick it off and care of what brings them income only?

  Maciej
