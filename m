Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3BTBGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:06:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:24776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab3BTBGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:06:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,698,1355126400"; 
   d="scan'208";a="293335553"
Date: Wed, 20 Feb 2013 09:06:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, jun.zhang@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-ID: <20130220010643.GA7595@localhost>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
 <1361023075.11130.12.camel@cliu38-desktop-build>
 <1361023812.11130.15.camel@cliu38-desktop-build>
 <20130218013852.GA11231@localhost>
 <20130219150123.07024b5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219150123.07024b5b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 03:01:23PM -0800, Andrew Morton wrote:
> On Mon, 18 Feb 2013 09:38:52 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Chuansheng,
> > 
> > It works fine on tip/next. Thanks for the fix!
> > 
> > Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> How did you test this?  What did you do?

I used the same kconfig to build a kernel from tip/next HEAD *plus*
the v2 patch. The result is, no smp_call_function_single/many warnings
are observed.

> afacit the patch adds additional warnings, so you must have had some
> buggy code and with the patch, runtime warnings are generated which
> inform you of that bug?

Andrew, the background is: Ingo has *reverted* the original patch that
triggered the smp_call_function_single warning from his tip tree, so
the test result means this patch's warning messages won't trigger in
my test boots.

Thanks,
Fengguang
