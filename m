Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252AbaFSVER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:04:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58084 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbaFSVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:04:13 -0400
Date: Thu, 19 Jun 2014 14:03:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619210308.GO4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
 <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
 <20140619205044.GX8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619205044.GX8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061921-1344-0000-0000-0000024F3A75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:50:44PM -0700, Andi Kleen wrote:
> On Thu, Jun 19, 2014 at 01:42:20PM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 19, 2014 at 03:31:56PM -0500, Christoph Lameter wrote:
> > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > 
> > > > That is a separate issue, but unnecessary calls to cond_resched()
> > > > should of course be removed -- no argument there.
> > > 
> > > It looks like we are fighting higher latencies by adding calls in most of
> > > the critical sections which will in turn increase the latencies that we
> > > are trying to reduce.
> > 
> > That is on battle in a larger war.  Another battle is to keep big systems
> > from choking and dying.  We need to win both battles, though I understand
> 
> If we really need cond_resched() now to stop systems from dying
> we did a really poor job at designing Linux. I hope it's not true,
> that would be really bad and point to some severe design problems
> elsewhere.

Or that systems are growing larger than anticipated by some of the
designs.  And there are some truly huge systems out there running
Linux, as has been mentioned on this thread several times.

							Thanx, Paul

