Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab3BTBWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:22:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:44517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455Ab3BTBWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:22:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,698,1355126400"; 
   d="scan'208";a="289331704"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "mina86@mina86.org" <mina86@mina86.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Jun" <jun.zhang@intel.com>
Subject: RE: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Thread-Topic: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Thread-Index: AQHODwaQ93TzHBTvfEy1cJeBqaA0SZiB8rEw
Date: Wed, 20 Feb 2013 01:22:09 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A236557@SHSMSX101.ccr.corp.intel.com>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <1361023075.11130.12.camel@cliu38-desktop-build>
 <1361023812.11130.15.camel@cliu38-desktop-build>
 <20130218013852.GA11231@localhost>
 <20130219150123.07024b5b.akpm@linux-foundation.org>
 <20130220010643.GA7595@localhost>
In-Reply-To: <20130220010643.GA7595@localhost>
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



> -----Original Message-----
> From: Wu, Fengguang
> Sent: Wednesday, February 20, 2013 9:07 AM
> To: Andrew Morton
> Cc: Liu, Chuansheng; mingo@kernel.org; peterz@infradead.org;
> jbeulich@suse.com; paulmck@linux.vnet.ibm.com; mina86@mina86.org;
> srivatsa.bhat@linux.vnet.ibm.com; linux-kernel@vger.kernel.org; Zhang, Jun
> Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
> smp_call_function_many()/single() in serving irq
> 
> On Tue, Feb 19, 2013 at 03:01:23PM -0800, Andrew Morton wrote:
> > On Mon, 18 Feb 2013 09:38:52 +0800
> > Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > > Chuansheng,
> > >
> > > It works fine on tip/next. Thanks for the fix!
> > >
> > > Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> >
> > How did you test this?  What did you do?
> 
> I used the same kconfig to build a kernel from tip/next HEAD *plus*
> the v2 patch. The result is, no smp_call_function_single/many warnings
> are observed.
> 
> > afacit the patch adds additional warnings, so you must have had some
> > buggy code and with the patch, runtime warnings are generated which
> > inform you of that bug?
> 
> Andrew, the background is: Ingo has *reverted* the original patch that
> triggered the smp_call_function_single warning from his tip tree, so
> the test result means this patch's warning messages won't trigger in
> my test boots.
I also locally tested the below several cases, thanks.
1/ local_bh_disable(), then called smp_call_function_single(), no WARNING;
2/ In timer callback, then called smp_call_function_single(), WARNING;

> 
> Thanks,
> Fengguang
