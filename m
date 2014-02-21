Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaBUUvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:51:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44326 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBUUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:51:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 21 Feb 2014 21:45:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221214548.4dd6373c@stein>
In-Reply-To: <1392929071-16555-5-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
	<1392929071-16555-5-git-send-email-tj@kernel.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20 Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> firewire core-device and sbp2 have been been multiplexing work items
> with multiple work functions.  Introduce fw_device_workfn() and
> sbp2_lu_workfn() which invoke fw_device->workfn and
> sbp2_logical_unit->workfn respectively and always use the two
> functions as the work functions and update the users to set the
> ->workfn fields instead of overriding work functions using
> PREPARE_DELAYED_WORK().
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

And lightly runtime-tested as well.

This doesn't actually touch sbp-target; the following Cc's could be
dropped:

> Cc: Chris Boot <bootc@bootc.net>
> Cc: linux-scsi@vger.kernel.org
> Cc: target-devel@vger.kernel.org
> ---
>  drivers/firewire/core-device.c | 22 +++++++++++++++-------
>  drivers/firewire/sbp2.c        | 17 +++++++++++++----
>  include/linux/firewire.h       |  1 +
>  3 files changed, 29 insertions(+), 11 deletions(-)

-- 
Stefan Richter
-=====-====- --=- =-=-=
http://arcgraph.de/sr/
