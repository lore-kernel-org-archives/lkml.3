Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaKJPuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:50:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaKJPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:50:13 -0500
Date: Mon, 10 Nov 2014 16:50:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>, Tejun Heo <tj@kernel.org>,
        "Auld, Will" <will.auld@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, h.peter.anvin@intel.com
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141110155009.GY10501@worktop.programming.kicks-ass.net>
References: <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <alpine.DEB.2.10.1410301610000.27874@vshiva-Udesk>
 <20141104131714.GR3219@twins.programming.kicks-ass.net>
 <20141106170323.GJ3592@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106170323.GJ3592@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:03:23PM +0000, Matt Fleming wrote:
> On Tue, 04 Nov, at 02:17:14PM, Peter Zijlstra wrote:
> > 
> > I don't like extending cpusets further. Its already a weird and too big
> > controller.
> > 
> > What is wrong with having a specific CQM controller and using it
> > together with cpusets where desired?
> 
> The specific problem that conflating cpusets and the CAT controller is
> trying to solve is that on some platforms the CLOS ID doesn't move with
> data that travels up the cache hierarchy, i.e. we lose the CLOS ID when
> data moves from LLC to L2.
> 
> I think the idea with pinning CLOS IDs to a specific cpu and any tasks
> that are using that ID is that it works around this problem out of the
> box, rather than requiring sysadmins to configure things.

So either the user needs to set that mode _and_ set cpu masks, or the
user needs to use cpusets and set masks, same difference to me.


