Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LLOwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:52:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:12586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3LLOwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="423606737"
Message-ID: <1386859952.6066.80.camel@tursulin-linux.isw.intel.com>
Subject: Re: Potentially unbounded allocations in seq_read?
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 14:52:32 +0000
In-Reply-To: <20131212142157.GD10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
	 <20131211174909.GW10323@ZenIV.linux.org.uk>
	 <1386784797.6066.63.camel@tursulin-linux.isw.intel.com>
	 <20131211180703.GY10323@ZenIV.linux.org.uk>
	 <1386855640.6066.73.camel@tursulin-linux.isw.intel.com>
	 <20131212134956.GC10323@ZenIV.linux.org.uk>
	 <1386856771.6066.77.camel@tursulin-linux.isw.intel.com>
	 <20131212142157.GD10323@ZenIV.linux.org.uk>
Organization: Intel Corporation UK Plc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 14:21 +0000, Al Viro wrote:
> On Thu, Dec 12, 2013 at 01:59:31PM +0000, Tvrtko Ursulin wrote:
> 
> > > a) *what* errors other than -ENAMETOOLONG?
> > 
> > Is this your way of saying there can't be any other errors from d_path?
> 
> Check yourself...  It is the only error that makes sense there and yes,
> it is the only one being returned.

Cool then, thats why I e-mailed you in the first place, because you know
this area very well. 

> > > b) d_path() not fitting into 2Mb is definitely a bug.  If you really have
> > > managed to get a dentry tree 1 million levels deep, you have much worse
> > > problems.
> > > c) which kernel version it is?
> > 
> > 3.10. I can't imagine this is an actual dentry tree somewhere, probably
> > just a bug of some sort. I'll probably hunt it down completely some time
> > next week, time permitting.
> 
> Sounds like missing backport of 118b23 ("cope with potentially long ->d_dname()
> output for shmem/hugetlb").  It *is* in -stable (linux-3.10.y has it since
> 3.10.17 as commit ad4c3c), but if your tree doesn't have it, that's the one
> to try first...

Yes that fixed it, thanks!

Regards,

Tvrtko


