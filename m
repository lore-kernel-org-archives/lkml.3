Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab3ICVNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:13:24 -0400
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:51172 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760742Ab3ICVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:13:23 -0400
Date: Tue, 3 Sep 2013 17:14:51 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
In-Reply-To: <20130903202844.GK16724@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1309031711001.25732@pianoman.cluster.toy>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org> <1366484783-15613-6-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy> <20130903202844.GK16724@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020204.522650F2.016A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Andi Kleen wrote:

> > > +	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
> > > +	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
> > > +	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
> > 
> > so if you specify these flags in branch_sample_type, what information
> > appears in the branch record?  
> 
> This is just a filter, so when set branches that do not satisfy
> the filter are not reported.

Is the implementation a direct mapping to the LBR documentation or has it 
been generic so non-Intel architectures can use it?

> The patches to export the new fields haven't been merged yet.

What does this mean?  The above values are exported as part of 
  include/uapi/linux/perf_event.h
Do they not work yet?

> >  What happens if you set both in transaction and not in?
> 
> Then you get all branches.

so what happens if you set neither "PERF_SAMPLE_BRANCH_IN_TX" nor
"PERF_SAMPLE_BRANCH_NO_TX"?  Logically you'd get no branches at all,
but that can't be true as all code prior to 3.11 didn't set those values.

Vince
