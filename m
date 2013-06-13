Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab3FMSmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:42:02 -0400
Received: from 1wt.eu ([62.212.114.60]:36304 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab3FMSmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:42:00 -0400
Date: Thu, 13 Jun 2013 20:41:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61 - x86/ptrace/gcc 4.7 build error
Message-ID: <20130613184156.GE27760@1wt.eu>
References: <20130610101557.GA3235@1wt.eu> <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de> <20130613175330.GC27760@1wt.eu> <alpine.DEB.2.10.1306132028230.24569@aurora.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306132028230.24569@aurora.sdinet.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 08:31:08PM +0200, Sven-Haegar Koch wrote:
> On Thu, 13 Jun 2013, Willy Tarreau wrote:
> 
> > Sven-Haegar, Christoph,
> > 
> > concerning the issue below, I could reproduce both Sven-Haegar's error (running
> > make headers_check with the patch applied) and Christoph's build error with gcc
> > 4.7 on i686 without the patch.
> > 
> > I noticed that neither syscall_trace_enter() nor syscall_trace_leave() were
> > called from C code, all were from pure asm. So I simply reverted the first
> > patch then removed the two function prototypes and everything is OK for me
> > now using gcc 4.7, i686 and x86_64.
> > 
> > I'm attaching the two patches here to be appled on top of 2.6.32.61, I would
> > like it if you could try in your environment to confirm that they correctly
> > fix the issue.
> 
> hello Willy,
> 
> With your two new patches applied on top I was able to build my kernel 
> package both using gcc 4.7 (Debian Wheezy) and gcc 4.4 (Debian Squeeze).

Great, thanks for the report!

> (But I did not try rebooting the server yet)

no pb, usually on that old kernels, we get build failure reports in the week of
the release and boot issues during the next month because it seems that not that
many people use them on machines where unplanned reboots are permitted :-)

Thanks !
Willy

