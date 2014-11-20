Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaKTPiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:38:46 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48182 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaKTPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:38:44 -0500
Date: Thu, 20 Nov 2014 10:38:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, drbd-dev@lists.linbit.com,
        Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 01/10] writeback: move backing_dev_info->state into
 bdi_writeback
Message-ID: <20141120153841.GF14877@htj.dyndns.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <1416299848-22112-2-git-send-email-tj@kernel.org>
 <20141120152702.GF2330@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120152702.GF2330@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Thu, Nov 20, 2014 at 04:27:02PM +0100, Jan Kara wrote:
>   Hum, does it make sense to convert BDI_sync_congested and
> BDI_async_congested? It contains information whether the *device* is
> congested and cannot take more work. I understand that in a cgroup world

Yeah, I mean, with cgroup writeback, the device itself doesn't matter.
The only thing writeback sees is that cgroup's slice of the device
whose congestion status can be independent from other slices of the
device.

> you want to throttle IO from a cgroup to a device so when you take
> bdi_writeback to be a per-cgroup structure you want some indication there
> that a particular cgroup cannot push more to the device. But is it that
> e.g. mdraid cares about a cgroup and not about the device?

I didn't update mdraid to support cgroup writeback yet but it depends
on how it's implemented.  If it just transmits back the pressure from
individual underlying cgroup split devices, it's the same.  If we
wanna put blkcg splitting in front of mdraid and keep the backend side
clear of cgroup splitting, it'd just send down everything as belonging
to the root cgroup.

Thanks.

-- 
tejun
