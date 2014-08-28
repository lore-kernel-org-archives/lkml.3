Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936503AbaH1Juf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:50:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936483AbaH1Jue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:50:34 -0400
Date: Thu, 28 Aug 2014 10:50:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "byungchul.park@lge.com" <byungchul.park@lge.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "arm64: use cpu_online_mask when using forced
 irq_set_affinity"
Message-ID: <20140828095050.GE22580@arm.com>
References: <1409131806-11276-1-git-send-email-byungchul.park@lge.com>
 <20140828093826.GC22580@arm.com>
 <53FEFB42.5060600@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FEFB42.5060600@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:49:54AM +0100, Sudeep Holla wrote:
> 
> 
> On 28/08/14 10:38, Will Deacon wrote:
> > On Wed, Aug 27, 2014 at 10:30:06AM +0100, byungchul.park@lge.com wrote:
> >> From: Byungchul Park <byungchul.park@lge.com>
> >>
> >> This reverts commit 601c942176d8ad8334118bddb747e3720bed24f8.
> >>
> >> This patch is designed to ensure that the cpu being offlined is not
> >> present in the affinity mask. But it is a bad idea to overwrite the
> >> affinity variable with cpu_online_mask, even in case that the current
> >> affinity already includes onlined cpus.
> >>
> >> So revert this patch to replace it with another one doing exactly
> >> what it intends.
> >
> > Sudeep: what's the right way forward for this? There seems to be general
> > agreement that the existing code is broken, but a bunch of different
> > `fixes'. Can we just take a straight port of what tglx proposed for ARM?
> > (changing force to false)
> >
> 
> Yes I agree but for that we need agreement from rmk and hence I asked to
> wait till we hear from rmk. Main issue raised by rmk is if some other
> interrupt controller implementation decide not to migrate away when
> force is false(theoretically possible).

Okey doke. Whatever solution we take should be the same for arm and arm64,
so I'll leave it with you.

Will
