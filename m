Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaKDNRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:17:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:37046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaKDNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:17:24 -0500
Date: Tue, 4 Nov 2014 14:17:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vikas Shivappa <vikas.shivappa@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, h.peter.anvin@intel.com
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141104131714.GR3219@twins.programming.kicks-ass.net>
References: <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <alpine.DEB.2.10.1410301610000.27874@vshiva-Udesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410301610000.27874@vshiva-Udesk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 04:18:33PM -0700, Vikas Shivappa wrote:
> One way to it is to merge the CAT cgroups into the cpuset . In essense there
> is no CAT cgroup seperately and we just have a new file 'cbm' in the cpuset.
> This would be visible only when system has Cache allocation support and the
> user can manipulate the cache bit mask here.
> The  user can use the already existing cpu_exclusive file in the cpuset to
> mark the cgroups to use exclusive CPUs.
> That way we simplify and reuse cpuset code/hierarchy .. ?

I don't like extending cpusets further. Its already a weird and too big
controller.

What is wrong with having a specific CQM controller and using it
together with cpusets where desired?
