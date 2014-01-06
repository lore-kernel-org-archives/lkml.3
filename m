Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaAFVsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:48:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:64862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbaAFVsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:48:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="454473822"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Topic: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYCAABYGAIAAIqSAgAAVLYCAAAYhgA==
Date: Mon, 6 Jan 2014 21:48:29 +0000
Message-ID: <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <20140104161050.GA24306@htj.dyndns.org>
	 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140104225058.GC24306@htj.dyndns.org>
	 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106111624.GB5623@twins.programming.kicks-ass.net>
	 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
	 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106180636.GG30183@twins.programming.kicks-ass.net>
	 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106212623.GH30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140106212623.GH30183@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.231]
Content-Type: text/plain; charset="utf-8"
Content-ID: <131767B7EE25224A9303CA54C3226C9E@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06LmgTK010633

On Mon, 2014-01-06 at 22:26 +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 08:10:45PM +0000, Waskiewicz Jr, Peter P wrote:
> > There is one per logical CPU.  However, in the current generation, they
> > report on the usage of the same L3 cache.  But the CPU takes care of the
> > resolution of which MSR write and read comes from the logical CPU, so
> > software doesn't need to lock access to it from different CPUs.
> 
> What are the rules of RMIDs, I can't seem to find that in the SDM and I
> think you're tagging cachelines with them. Which would mean that in
> order to (re) use them you need a complete cache (L3) wipe.

The cacheline is tagged internally with the RMID as part of the waymask
for the thread in the core.

> Without a wipe you keep having stale entries of the former user and no
> clear indication on when your numbers are any good.

That can happen, yes.  If you have leftover cache data from a process
that died that hasn't been evicted yet and it's assigned to the RMID
you're using, you will see its included cache occupancy to the overall
numbers.

> Also, is there any sane way of shooting down the entire L3?

That is a question I'd punt to hpa, but I'll ask him.  Looking around
though, a WBINVD would certainly nuke things, but would hurt
performance.  We could get creative with INVPCID as a process dies.  Let
me ask him though and see if there's a good way to tidy up.

-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
