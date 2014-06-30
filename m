Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaF3OpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:45:20 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaF3OpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:45:19 -0400
Date: Mon, 30 Jun 2014 16:45:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 14/16] perf, x86: enable LBR callstack when
 recording callchain
Message-ID: <20140630144516.GJ5714@two.firstfloor.org>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-15-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404118253-19532-15-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 04:50:51PM +0800, Yan, Zheng wrote:
> If a task specific event wants user space callchain but does not want
> branch stack sampling, enable the LBR call stack facility implicitly.
> The LBR call stack facility can help perf to get user space callchain
> in case of there is no frame pointer.
> 
> Note: this feature only affects how to get user callchain. The kernel
> callchain is always got by frame pointers.

I'm not sure I like this. If frame pointer works the LBR state saving
is not needed. This would basically always turn it on right?

Perhaps turn it on lazily if the frame pointer resolution fails a few
times.

An explicit switch would be still better.

-Andi
