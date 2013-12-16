Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3LPOnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:43:08 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39390 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753859Ab3LPOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:43:07 -0500
Date: Mon, 16 Dec 2013 14:42:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 4/4] arm64: add early_ioremap support
Message-ID: <20131216144246.GG17713@arm.com>
References: <1385606679-30446-1-git-send-email-msalter@redhat.com>
 <1385606679-30446-5-git-send-email-msalter@redhat.com>
 <20131205162800.GB1495@darko.cambridge.arm.com>
 <1386350449.1861.196.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386350449.1861.196.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:20:49PM +0000, Mark Salter wrote:
> On Thu, 2013-12-05 at 16:28 +0000, Catalin Marinas wrote:
> > On Thu, Nov 28, 2013 at 02:44:39AM +0000, Mark Salter wrote:
> > > + * These 'compile-time allocated' memory buffers are
> > > + * page-sized. Use set_fixmap(idx,phys) to associate
> > > + * physical memory with fixmap indices.
> > > + *
> > > + */
> > > +enum fixed_addresses {
> > > +	FIX_EARLYCON,
> > > +	__end_of_permanent_fixed_addresses,
> > > +
> > > +	/*
> > > +	 * Temporary boot-time mappings, used by early_ioremap(),
> > > +	 * before ioremap() is functional.
> > > +	 */
> > 
> > How temporary are this mappings? The early console may not be disabled
> > at run-time, so it still needs the mapping.
> 
> It varies by arch, but we have flexibility on arm64 because there is a
> dedicated pmd which stays around forever. So, you see the FIX_EARLYCON
> above is a "permanent" mapping which isn't really an early_ioremap
> mapping. The earlyprintk code uses set_fixmap_io. I suppose this could
> have been broken up into two patches, one fixmap, and one early_ioremap.
> To answer your concern, the earlyprintk mapping doesn't go away. The
> early_ioremap mappings should be temporary and there's a checker for
> that which is run at late_initcall time.

OK, thanks for clarification, I don't think it's worth splitting the
patch.

-- 
Catalin
