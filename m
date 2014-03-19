Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaCSBP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:15:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:30086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366AbaCSBPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:15:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,681,1389772800"; 
   d="scan'208";a="494749986"
Date: Wed, 19 Mar 2014 09:15:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [drbd] Kernel panic - not syncing: Out of memory and no killable
 processes...
Message-ID: <20140319011548.GA8080@localhost>
References: <20140318140717.GA21372@localhost>
 <20140318143015.GB18403@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140318143015.GB18403@soda.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Tue, Mar 18, 2014 at 03:30:16PM +0100, Lars Ellenberg wrote:
> On Tue, Mar 18, 2014 at 10:07:17PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > We get the below OOM errors in our KVM boot tests and they are
> > bisected to
> > 
> > commit 23361cf32b58efdf09945a64e1d8d41fa6117157
> 
> We have been there before:

Yeah, sorry I forgot that.. Just tried the suggested
"drbd.minor_count=8" and it helps! Thank you all for the tip!

Cheers,
Fengguang

> .---
> | Date: Wed, 12 Jun 2013 18:11:43 +0800
> | From: Fengguang Wu <fengguang.wu@intel.com>
> | To: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
> | Subject: Re: [drbd?] Kernel panic - not syncing: Out of memory and no killable processes...
> | Message-ID: <20130612101143.GA13837@localhost>
> | 
> | On Tue, Jun 11, 2013 at 05:33:27PM +0200, Lars Ellenberg wrote:
> | > On Fri, Jun 07, 2013 at 10:31:54AM +0800, Fengguang Wu wrote:
> | > > Greetings,
> | > >
> | > > My "kvm -m 256" reliably goes Out Of Memory after this commit.  It may
> | > > not be the only one that eats up the memory, however I wonder how much
> | > > memory consumption this commit added? Thanks!
> 
> ...
> 
> | > We scale certain mempools and reserves with
> | > DRBD_MAX_BIO_SIZE/PAGE_SIZE * minor_count.
> | >
> | > DRBD_MAX_BIO_SIZE has been increased by this patch,
> | > resulting in more memory allocated to those reserved pools.
> | >
> | > Please just scale down the "minor_count" parameter.
> | > You can use the module parameter (e.g. modprobe drbd minor_count=8),
> | > or, compiled in, use the kernel command line parameter drbd.minor_count=8.
> | >
> | > Though "minor_count" at some point used to be the hard limit for the number of
> | > minor devices (allocation of an array of corresponding size), that has
> | > long since changed, and now it is really only used as scaling factor for
> | > these mempools.
> | 
> | Got it, thank you very much for the helpful tips and explanations!
> | I'll add the drbd.minor_count=8 option.
> | 
> | Thanks,
> | Fengguang
> `---
> 
> Does that help?
> 
> -- 
> : Lars Ellenberg
> : LINBIT | Your Way to High Availability
> : DRBD/HA support and consulting http://www.linbit.com
> 
> DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
