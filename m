Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaAFSGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:06:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:57365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaAFSGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:06:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="454372695"
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
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYCAABJmAIAAA2cA
Date: Mon, 6 Jan 2014 18:05:59 +0000
Message-ID: <1389031548.32504.29.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
	 <20140104161050.GA24306@htj.dyndns.org>
	 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140104225058.GC24306@htj.dyndns.org>
	 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106111624.GB5623@twins.programming.kicks-ass.net>
	 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
	 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106175338.GF30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140106175338.GF30183@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.231]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D144093FD4D1E34EAF6EEC229A396FA6@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06I6RUa008752

On Mon, 2014-01-06 at 18:53 +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 04:47:57PM +0000, Waskiewicz Jr, Peter P wrote:
> > > Yeah that's not accurate, nor desired I think, because you get into
> > > horrible problems with hierarchies, do child groups belong to your RMID
> > > or not?
> > 
> > I'd rather not support a child group of a child group.  Only groups off
> > the root, and each group would be assigned an RMID when it's activated
> > for monitoring.
> 
> Yeah, that's a complete non started for cgroups. Cgroups need to be
> completely hierarchical.
> 
> So even the root group should represent all tasks; which if you fragment
> RMIDs on child cgroups doesn't work anymore.

The root group does represent all tasks in the current patchset on RMID
0.  Then any child assigned to another group will be assigned to a
different RMID.  It looks like this:

                       root (rmid 0)
                       /  \
             (rmid 4) g1  g2 (rmid 16)

We could keep going down from there, but I don't see it buying anything
extra.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
