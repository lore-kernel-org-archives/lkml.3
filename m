Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaDPWtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:49:45 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:54538 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbaDPWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:49:26 -0400
X-Greylist: delayed 1625 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 18:49:26 EDT
Date: Thu, 17 Apr 2014 01:22:17 +0300 (EEST)
From: mroos@linux.ee
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140416.145822.1317931249717152474.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1404170119550.20193@math.ut.ee>
References: <20131022174612.GC24448@blackmetal.musicnaut.iki.fi> <20131022.135442.1072093301788210177.davem@davemloft.net> <20140414184353.GA5630@drone.musicnaut.iki.fi> <20140416.145822.1317931249717152474.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just for the archives, I got one of these again with 3.14:
> 
> Meelis and Aaro, thanks again for all of your reports.
> 
> After pouring over a lot of the data and auditing some code I'm
> suspecting it's a problem with transparent huge pages.
> 
> One thing you two can do to help me further confirm this is to run
> with THP disabled for a while and see if you still get the log
> messages.

I have snice turned off CONFIG_TRANSPARENT_HUGEPAGE on 3 of 4 servers 
that had this problem (actually most of my sparc64 machines) and the 4th 
has

CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not se

and also has not had this problem since then. All 4 machines have been 
running through most -rc's of every kernel.

-- 
Meelis Roos <mroos@linux.ee>
