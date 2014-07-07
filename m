Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaGGN51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:57:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:49551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbaGGN5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="558329630"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Thread-Topic: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Thread-Index: AQHPlmMbuLIQQh7qiUeG9QES28P7JpuNbz6AgACLf4CAABTVgIAGkT8g
Date: Mon, 7 Jul 2014 13:57:16 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014C6431@SHSMSX103.ccr.corp.intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
 <20140703073321.GU19379@twins.programming.kicks-ass.net>
 <20140703155237.GQ5714@two.firstfloor.org>
 <20140703170711.GW19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140703170711.GW19379@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Thu, Jul 03, 2014 at 05:52:37PM +0200, Andi Kleen wrote:
> > > If there's active LBR users out there, we should refuse to enable PT
> > > and vice versa.
> >
> > This doesn't work, e.g. hardware debuggers can take over at any time.
> 
> Tough cookies. Hardware debuggers get to deal with whatever crap they
> cause.

If so, I think I may discard this patch (2/3). I will resubmit the other two patches as a patch set to only handle the KVM issue we found.
It checks the access of LBR and extra MSRs at the initialization time and set the flags. So we just need to check the flags at runtime and avoid the protection by _safe(). 

For Intel PT and LBR handling, since the PT codes haven't been integrated yet, I will try to implement another patch later.
The patch will add flags for LBR and PT.
When enabling PT, it checks LBR flag and update the PT flag. When enabling LBR, it checks PT flag and update the LBR flag. When disabling LBR/PT, we just update the related flags. we don't need to add _safe or extra rmsr in fast path. 

How do you think?

Thanks,
Kan
