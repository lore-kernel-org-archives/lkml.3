Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab3ICTY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:24:28 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:46977 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753889Ab3ICTYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:24:25 -0400
Date: Tue, 3 Sep 2013 15:25:50 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
In-Reply-To: <1366484783-15613-6-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org> <1366484783-15613-6-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020204.52263768.016B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Apr 2013, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Haswell has two additional LBR from flags for TSX: intx and abort, implemented
> as a new v4 version of the LBR format.
> 
> Handle those in and adjust the sign extension code to still correctly extend.
> The flags are exported similarly in the LBR record to the existing misprediction
> flag

I'm trying to update the perf_event_open() manpage for the new changes 
that were in Linux 3.11 and am having trouble getting info on exactly
what these new fields mean.

> +	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
> +	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
> +	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */

so if you specify these flags in branch_sample_type, what information
appears in the branch record?  

If you get an abort, what address appears in the record?

What does it mean in regards to a branch entry to be or not be in a 
transaction?  

If you set "in transaction" does that then only record branches that are 
in transactions?  What happens if you set both in transaction and not in?

Is there some sort of document from intel you can link to that describes 
all of this?

Thanks,

Vince

