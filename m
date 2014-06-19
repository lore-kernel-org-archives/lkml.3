Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbaFSVNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:13:16 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:50768 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934620AbaFSVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:13:15 -0400
Date: Thu, 19 Jun 2014 16:13:12 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140619204220.GJ4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
References: <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com> <20140618203052.GT4669@linux.vnet.ibm.com> <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com> <alpine.DEB.2.11.1406190941180.2785@gentwo.org> <20140619180916.GE4904@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191531020.4002@gentwo.org> <20140619204220.GJ4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> On Thu, Jun 19, 2014 at 03:31:56PM -0500, Christoph Lameter wrote:
> > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> >
> > > That is a separate issue, but unnecessary calls to cond_resched()
> > > should of course be removed -- no argument there.
> >
> > It looks like we are fighting higher latencies by adding calls in most of
> > the critical sections which will in turn increase the latencies that we
> > are trying to reduce.
>
> That is on battle in a larger war.  Another battle is to keep big systems
> from choking and dying.  We need to win both battles, though I understand
> that you are focused primarily on latency reduction.  I don't get that
> luxury because RCU is used across the board.

At least reduce the increased latencies to a processor or put it somewhere
outside of the regular execution paths. Sprinkling this throughout the
kernel via a inline function that did not generate code in the non debug
situation before is not that nice.

