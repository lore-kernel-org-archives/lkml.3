Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab3FTJIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:08:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47592 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509Ab3FTJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:08:20 -0400
Date: Thu, 20 Jun 2013 10:07:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jed Davis <jld@mozilla.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: ARM: Record the user-mode PC in the call chain.
Message-ID: <20130620090728.GA2842@mudshark.cambridge.arm.com>
References: <20130613232111.GA12536@mozilla.com>
 <20130618131319.GC6801@mudshark.cambridge.arm.com>
 <20130620031706.GB27428@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620031706.GB27428@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 04:17:06AM +0100, Jed Davis wrote:
> On Tue, Jun 18, 2013 at 02:13:19PM +0100, Will Deacon wrote:
> > On Fri, Jun 14, 2013 at 12:21:11AM +0100, Jed Davis wrote:
> > > With this change, we no longer lose the innermost entry in the user-mode
> > > part of the call chain.  See also the x86 port, which includes the ip.
> > > 
> > > It's possible to partially work around this problem by post-processing
> > > the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
> > > wasn't in the kernel when the sample was taken.
> > 
> > Thanks. I guess we need something similar for arm64 too. Could you cook a
> > similar patch please?
> 
> Done (and tested, on the ARM V8 Foundation Model).

Wow, I didn't expect you to test it. Thanks!

> It looked as if the powerpc and sparc ports might have similar issues,
> but I haven't checked on them yet.

I can extract some hardware from the pile in the corner of my flat if you
want a hand with testing.

Will
