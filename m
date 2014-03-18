Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaCROiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:38:06 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:57239 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaCROiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:38:02 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 10:38:01 EDT
Date: Tue, 18 Mar 2014 15:30:16 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [drbd] Kernel panic - not syncing: Out of memory and no killable
 processes...
Message-ID: <20140318143015.GB18403@soda.linbit>
Mail-Followup-To: Fengguang Wu <fengguang.wu@intel.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
References: <20140318140717.GA21372@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140318140717.GA21372@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:07:17PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> We get the below OOM errors in our KVM boot tests and they are
> bisected to
> 
> commit 23361cf32b58efdf09945a64e1d8d41fa6117157

We have been there before:

.---
| Date: Wed, 12 Jun 2013 18:11:43 +0800
| From: Fengguang Wu <fengguang.wu@intel.com>
| To: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
| Subject: Re: [drbd?] Kernel panic - not syncing: Out of memory and no killable processes...
| Message-ID: <20130612101143.GA13837@localhost>
| 
| On Tue, Jun 11, 2013 at 05:33:27PM +0200, Lars Ellenberg wrote:
| > On Fri, Jun 07, 2013 at 10:31:54AM +0800, Fengguang Wu wrote:
| > > Greetings,
| > >
| > > My "kvm -m 256" reliably goes Out Of Memory after this commit.  It may
| > > not be the only one that eats up the memory, however I wonder how much
| > > memory consumption this commit added? Thanks!

...

| > We scale certain mempools and reserves with
| > DRBD_MAX_BIO_SIZE/PAGE_SIZE * minor_count.
| >
| > DRBD_MAX_BIO_SIZE has been increased by this patch,
| > resulting in more memory allocated to those reserved pools.
| >
| > Please just scale down the "minor_count" parameter.
| > You can use the module parameter (e.g. modprobe drbd minor_count=8),
| > or, compiled in, use the kernel command line parameter drbd.minor_count=8.
| >
| > Though "minor_count" at some point used to be the hard limit for the number of
| > minor devices (allocation of an array of corresponding size), that has
| > long since changed, and now it is really only used as scaling factor for
| > these mempools.
| 
| Got it, thank you very much for the helpful tips and explanations!
| I'll add the drbd.minor_count=8 option.
| 
| Thanks,
| Fengguang
`---

Does that help?

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
