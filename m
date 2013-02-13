Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3BMJKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:10:31 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39345 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3BMJK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:10:27 -0500
Date: Wed, 13 Feb 2013 10:10:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 5/5] perf, x86: Move NMI clearing to end of PMI handler
 after the counter registers are reset
Message-ID: <20130213091022.GB7630@gmail.com>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
 <1360265019-23865-6-git-send-email-andi@firstfloor.org>
 <20130212084346.GB19475@gmail.com>
 <20130212151426.GA30577@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212151426.GA30577@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Feb 12, 2013 at 09:43:46AM +0100, Ingo Molnar wrote:
> > Was this stress-tested on all affected main CPU types, or only 
> > on Haswell?
> 
> I tested it on Haswell and Ivy Bridge. I can also try Westmere 
> and a Saltwell(Atom), but for the majority of other family 6 
> systems I'll need to rely on the community.

The systems you tested should be OK.

> White listing is somewhat difficult because it affects the 
> architectural mode too.

Yeah, I'd rather avoid that.

> I don't really expect problems from this change, we should 
> probably have always done it like this.

I expect potential problems: the ordering of the operations in 
the NMI handler was always very fragile, resulting in hard to 
debug hangs - which sometimes needed hours long very intense PMU 
stress-testing to trigger.

That is why I asked how heavily you've tested this. Once the 
series passes review I'll keep this patch last to make it easy 
to revert/zap if it causes problems.

Thanks,

	Ingo
