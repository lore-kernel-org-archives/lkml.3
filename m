Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaILIbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:31:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:54874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbaILIbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:31:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="477075097"
Message-ID: <1410510664.7023.35.camel@linux.intel.com>
Subject: Re: [RFC Part2 v1 0/2] Refine the way to initialize IRQ for apb
 timer
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 11:31:04 +0300
In-Reply-To: <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
References: <y>
	 <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 16:20 +0800, Jiang Liu wrote:
> Hi David and Andy,
> 	Could you please help to test these two patches on Intel MID
> platforms? It's based on Thomas patch to refine the way to initialize
> IRQ for apb timers. It should apply to the mainstream kernel.
> 

1) clean command line — OK

2) x86_intel_mid_timer=apbt_only — HANGS in the same place as w/o
Thomas' patch (see my last mail), but no warnings are printed

3) x86_intel_mid_timer=lapic_and_apbt — HANGS: same as above which is
differs to the same conditions w/o any patches (yours and Thomas')


> Jiang Liu (2):
>   intel_mid: Kill unused function apbt_quick_calibrate()
>   intel_mid: Refine the way to initialize IRQ for apb timer
> 
>  arch/x86/include/asm/apb_timer.h        |    2 -
>  arch/x86/kernel/apb_timer.c             |   79 +++++--------------------------
>  arch/x86/platform/intel-mid/intel-mid.c |   18 +++----
>  arch/x86/platform/intel-mid/sfi.c       |   20 ++++----
>  4 files changed, 30 insertions(+), 89 deletions(-)
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

