Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaCNI0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:26:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:43052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbaCNI0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:26:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,653,1389772800"; 
   d="scan'208";a="499723250"
Date: Fri, 14 Mar 2014 10:33:55 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: next-20140313 - build error in e1000e driver
Message-ID: <20140314083354.GC5018@intel.com>
References: <59774.1394739168@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59774.1394739168@turing-police.cc.vt.edu>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:32:48PM -0400, Valdis Kletnieks wrote:
> My kernel has CONFIG_PM_SLEEP=n, which leads to hilarity...
> 
>   CC      drivers/net/ethernet/intel/e1000e/netdev.o
> drivers/net/ethernet/intel/e1000e/netdev.c:7079:13: error: 'e1000e_pm_suspend' undeclared here (not in a function)
>   .suspend = e1000e_pm_suspend,
>              ^
> drivers/net/ethernet/intel/e1000e/netdev.c:7080:13: error: 'e1000e_pm_resume' undeclared here (not in a function)
>   .resume  = e1000e_pm_resume,
>              ^
> make[5]: *** [drivers/net/ethernet/intel/e1000e/netdev.o] Error 1
> make[4]: *** [drivers/net/ethernet/intel/e1000e] Error 2
> make[3]: *** [drivers/net/ethernet/intel] Error 2
> make[2]: *** [drivers/net/ethernet] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> Commit 38a529b5d4 claims to fix a related issue, but doesn't seem to do
> so correctly.

It fixes it correctly. The problem is that it got broke again with
the following commit:

d392f8ddb8 e1000e: Refactor PM flows
