Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbaGXTxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:53:32 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:53109 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934246AbaGXTxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:53:31 -0400
Date: Thu, 24 Jul 2014 22:52:39 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se
Subject: Re: [PATCH 1/6] openrisc: add Kconfig for l.lwa and l.swa atomic
 instructions
Message-ID: <20140724195237.GA12313@chokladfabriken.org>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <1406150296-13308-2-git-send-email-stefan.kristiansson@saunalahti.fi>
 <20140723222601.51a8b788@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723222601.51a8b788@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:26:01PM +0100, One Thousand Gnomes wrote:
> > +config OPENRISC_HAVE_INST_LWA_SWA
> > +	bool "Have instruction l.lwa and l.swa"
> > +	help
> > +	  Select this if your implementation have l.lwa and l.swa atomic
> > +	  instructions.
> > +
> >  endmenu
> 
> Please do everyone a favour - sort all these out at runtime, add an
> architectural feature bits ROM address or catch the traps and use the
> alterntatives logic or something.
> 

Detecting whether the instruction exists is of course trivial,
the hard part is what to do with this information at runtime.
My initial intention was to add emulation for the l.lwa and l.swa
instructions in the kernel, so a CPU without them would still
be able to run a kernel with CONFIG_OPENRISC_HAVE_INST_LWA_SWA enabled,
but inefficiently.

I will in either case add the kernel emulation,
since it's still needed to handle userspace occurences of these
instructions, perhaps that patch belong to this series as well.

I wasn't familiar with the alternatives logic before, so I had
to look it up.
Correct me if I'm wrong, but from what I gathered, the approach
that takes is especially suitable to fixup instructions that
are similar to each others but have slightly different properties
(the lock prefix to cmpxchg being the canonical example).

I guess it'd be *possible* to still use this method to implement
alternatives that would work in the UP case by disabling
context-switch and perform normal loads and stores in place
of the l.lwa and l.swa instructions, but is it really a good approach?

Stefan
