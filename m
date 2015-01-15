Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbbAOPbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:31:33 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:35867 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbbAOPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:31:30 -0500
Date: Thu, 15 Jan 2015 15:31:27 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150115153127.GB3479@codeblueprint.co.uk>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150106171712.GH3337@twins.programming.kicks-ass.net>
 <20150109121401.GB495@console-pimps.org>
 <20150109130250.GH29390@twins.programming.kicks-ass.net>
 <20150109152442.GG495@console-pimps.org>
 <20150109155835.GJ29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109155835.GJ29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan, at 04:58:35PM, Peter Zijlstra wrote:
> On Fri, Jan 09, 2015 at 03:24:42PM +0000, Matt Fleming wrote:
> > 
> > Right, but now we need a "steal limit", so we know when to stop stealing
> > active RMIDs.
> > 
> > 	(cqm_max_rmid + 1) / 4 ?
> > 
> > I guess any limit is better than no limit.
> 
> Yeah, that'll work, when the free+limbo count is 1/4th the total we
> should stop pulling more plugs.

We actually stop pulling plugs as soon as there's a single RMID
available to use as the rotation RMID. When we find one, we don't wait
any longer to do any kind of batching (though if we go from zero
available RMIDs, to 5 RMIDs in one loop, we'll pickup all 5 RMIDs).

-- 
Matt Fleming, Intel Open Source Technology Center
