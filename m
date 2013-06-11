Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3FKPdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:33:33 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:38342 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3FKPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:33:28 -0400
Date: Tue, 11 Jun 2013 17:33:27 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [drbd?] Kernel panic - not syncing: Out of memory and no
 killable processes...
Message-ID: <20130611153326.GK20369@soda.linbit>
Mail-Followup-To: Fengguang Wu <fengguang.wu@intel.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
References: <20130607023154.GA13344@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130607023154.GA13344@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:31:54AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> My "kvm -m 256" reliably goes Out Of Memory after this commit.  It may
> not be the only one that eats up the memory, however I wonder how much
> memory consumption this commit added? Thanks!
> 

Out of curiosity, what exactly is it you are doing there?
What project or appliance or behaviour or product or paper is the goal?


We scale certain mempools and reserves with
DRBD_MAX_BIO_SIZE/PAGE_SIZE * minor_count.

DRBD_MAX_BIO_SIZE has been increased by this patch,
resulting in more memory allocated to those reserved pools.

Please just scale down the "minor_count" parameter.
You can use the module parameter (e.g. modprobe drbd minor_count=8),
or, compiled in, use the kernel command line parameter drbd.minor_count=8.

Though "minor_count" at some point used to be the hard limit for the number of
minor devices (allocation of an array of corresponding size), that has
long since changed, and now it is really only used as scaling factor for
these mempools.

	Lars


-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com
DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
