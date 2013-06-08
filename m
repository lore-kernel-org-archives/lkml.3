Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3FHCPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:15:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:3876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3FHCPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,825,1363158000"; 
   d="scan'208";a="346651530"
Date: Sat, 8 Jun 2013 10:15:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kbuild-all@01.org,
        Christopher Li <sparse@chrisli.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel/workqueue.c:4435:61: sparse: expression using sizeof bool
Message-ID: <20130608021509.GA13207@localhost>
References: <51afd3ac.1kKgJcnM4PAV+Agb%fengguang.wu@intel.com>
 <20130607141521.4000962d5ac0d7fcd54800cf@linux-foundation.org>
 <20130607220351.GE14781@mtj.dyndns.org>
 <20130607184614.45418364.akpm@linux-foundation.org>
 <20130608020549.GN14781@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130608020549.GN14781@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

// CC sparse people.

On Fri, Jun 07, 2013 at 07:05:49PM -0700, Tejun Heo wrote:
> Hello, Andrew.
> 
> On Fri, Jun 07, 2013 at 06:46:14PM -0700, Andrew Morton wrote:
> > I believe sizeof(bool) can vary between compilers (on gcc it's 1) but
> > that doesn't matter here.
> 
> Looking at the warning, I originally suspected that maybe the standard
> was crazy enough to allow mixed usages of different sizes for bool as
> the compiler sees fit.  Just scanned the spec, nothing that insane.
> It's a proper integeral type, so I'm now more puzzled why sparse is
> warning about sizeof(bool).
> 
> > sizeof(enum) can vary between compilers as well.  In fact I've seen a
> > compiler which used 2 if the enumerated values were 0..65535, and 4
> > otherwise.  So warning about sizeof(enum) would be a bit more useful
> > than about sizeof(bool).
> 
> Oh yeah, gcc does that too.  If the enum definition contains a number
> larger than 32bit, it'll grow it to 64bit.
> 
>  #include <stdio.h>
> 
>  enum { ENUM_A = 1LU };
>  enum { ENUM_B = 1LU << 31 };
>  enum { ENUM_C = 1LU << 32 };
> 
>  int main(void)
>  {
> 	 printf("%zu %zu %zu\n", sizeof(ENUM_A), sizeof(ENUM_B), sizeof(ENUM_C));
> 	 return 0;
>  }
> 
>  $ ./a.out
>  4 4 8
> 
> Whether sparse should trigger a warning on it, I don't know.
> 
> Thanks.
> 
> -- 
> tejun
