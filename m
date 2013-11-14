Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3KNLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:15:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3KNLPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:15:22 -0500
Date: Thu, 14 Nov 2013 12:15:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131114111514.GH16796@laptop.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <20131114105017.GD543@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114105017.GD543@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 04:20:17PM +0530, Srikar Dronamraju wrote:
> > +			/*
> > +			 * build_sched_domains() -> init_sched_groups_power()
> > +			 * gets here before we've attached the domains to the
> > +			 * runqueues.
> > +			 *
> > +			 * Use power_of(), which is set irrespective of domains
> > +			 * in update_cpu_power().
> > +			 *
> > +			 * This avoids power/power_orig from being 0 and
> > +			 * causing divide-by-zero issues on boot.
> > +			 *
> > +			 * Runtime updates will correct power_orig.
> > +			 */
> > +			if (!rq->sd) {
> 
> Because this condition is only true during boot up, I am now
> thinking if we should do mark this as unlikely i.e if (unlikely(!rq->sd)) {

Makes sense, edited the patch.

