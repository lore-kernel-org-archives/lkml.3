Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405Ab3IDOUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:20:01 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:45389 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755194Ab3IDOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:20:00 -0400
Date: Wed, 4 Sep 2013 10:21:27 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@linux.intel.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
In-Reply-To: <20130903223751.GN19750@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1309041015130.28706@pianoman.cluster.toy>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org> <1366484783-15613-6-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy> <20130903202844.GK16724@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1309031711001.25732@pianoman.cluster.toy> <20130903223751.GN19750@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.5227418F.0038,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013, Andi Kleen wrote:

> > What does this mean?  The above values are exported as part of 
> >   include/uapi/linux/perf_event.h
> > Do they not work yet?
> 
> You can filter on the fields, but you can't see them outside
> the kernel driver yet.  The patch to see them is still pending.

so you can filter for aborts, but they'll never show up in the lbr[]
sample buffer?

> > > >  What happens if you set both in transaction and not in?
> > > 
> > > Then you get all branches.
> > 
> > so what happens if you set neither "PERF_SAMPLE_BRANCH_IN_TX" nor
> > "PERF_SAMPLE_BRANCH_NO_TX"?  Logically you'd get no branches at all,
> > but that can't be true as all code prior to 3.11 didn't set those values.
> 
> Then you get all branches too
> 
> (that's how all the other filters work too)

This is a really confusing API

so does setting "PERF_SAMPLE_BRANCH_ANY" also enable all of the TX types?

Is leaving branch_sample_type at 0 the same as setting it to all 1s?

Vince


