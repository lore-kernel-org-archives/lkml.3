Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3FLKLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:11:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:23371 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3FLKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,851,1363158000"; 
   d="scan'208";a="348626518"
Date: Wed, 12 Jun 2013 18:11:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [drbd?] Kernel panic - not syncing: Out of memory and no
 killable processes...
Message-ID: <20130612101143.GA13837@localhost>
References: <20130607023154.GA13344@localhost>
 <20130611153326.GK20369@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611153326.GK20369@soda.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 05:33:27PM +0200, Lars Ellenberg wrote:
> On Fri, Jun 07, 2013 at 10:31:54AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > My "kvm -m 256" reliably goes Out Of Memory after this commit.  It may
> > not be the only one that eats up the memory, however I wonder how much
> > memory consumption this commit added? Thanks!
> > 
> 
> Out of curiosity, what exactly is it you are doing there?
> What project or appliance or behaviour or product or paper is the goal?

Philipp, this is the 0day kernel testing project from Intel OTC.

We are running regular build/boot tests for 300+ kernel git trees and
aim to find and report problems ASAP. We test 30000+ kernel boots
every day (mainly in KVM).

> We scale certain mempools and reserves with
> DRBD_MAX_BIO_SIZE/PAGE_SIZE * minor_count.
> 
> DRBD_MAX_BIO_SIZE has been increased by this patch,
> resulting in more memory allocated to those reserved pools.
> 
> Please just scale down the "minor_count" parameter.
> You can use the module parameter (e.g. modprobe drbd minor_count=8),
> or, compiled in, use the kernel command line parameter drbd.minor_count=8.
> 
> Though "minor_count" at some point used to be the hard limit for the number of
> minor devices (allocation of an array of corresponding size), that has
> long since changed, and now it is really only used as scaling factor for
> these mempools.

Got it, thank you very much for the helpful tips and explanations!
I'll add the drbd.minor_count=8 option.

Thanks,
Fengguang
