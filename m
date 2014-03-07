Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaCGPSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:18:30 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:57643 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaCGPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:18:24 -0500
Date: Fri, 7 Mar 2014 10:18:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140307151820.GD30778@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-5-git-send-email-tj@kernel.org>
 <20140221214548.4dd6373c@stein>
 <20140305223432.61b79278@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305223432.61b79278@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:34:32PM +0100, Stefan Richter wrote:
> On Feb 21 Stefan Richter wrote:
> > On Feb 20 Tejun Heo wrote:
> > > PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> > > and a nasty surprise in terms of reentrancy guarantee as workqueue
> > > considers work items to be different if they don't have the same work
> > > function.
> > > 
> > > firewire core-device and sbp2 have been been multiplexing work items
> > > with multiple work functions.  Introduce fw_device_workfn() and
> > > sbp2_lu_workfn() which invoke fw_device->workfn and
> > > sbp2_logical_unit->workfn respectively and always use the two
> > > functions as the work functions and update the users to set the
> > > ->workfn fields instead of overriding work functions using
> > > PREPARE_DELAYED_WORK().
> > > 
> > > It would probably be best to route this with other related updates
> > > through the workqueue tree.
> > > 
> > > Compile tested.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > > Cc: linux1394-devel@lists.sourceforge.net
> > 
> > Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Actually, there is something missing in the changelog:
> 
>    This fixes a variety of possible regressions since a2c1c57be8d9
>    "workqueue: consider work function when searching for busy work items"
>    due to which fw_workqueue lost its required non-reentrancy property.
> 
>    Cc: stable@kernel.org # v3.9+
>    Cc: stable@kernel.org # v3.8.2+
>    Cc: stable@kernel.org # v3.4.60+
>    Cc: stable@kernel.org # v3.2.40+
> 
> Tejun, will you be adding these and push the patch at the latest before
> v3.15-rc1?  Otherwise, I will take over the patch and push it still this
> week, i.e. before v3.14-rc6.

I'll push this one through wq/for-3.14-fixes and route the others
through wq/for-3.15.

Thanks.

-- 
tejun
