Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaETD4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:56:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57980 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaETD4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:56:05 -0400
X-Nat-Received: from [202.181.97.72]:54800 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400558070.13671
Message-Id: <201405200354.s4K3sTUx057458@www262.sakura.ne.jp>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2014 12:54:29 +0900
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp> <20140520004449.GE18954@dastard>
In-Reply-To: <20140520004449.GE18954@dastard>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20052014 #7957577, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> So, XFS should be passing kswapd context to the workqueue allocation
> context. The patch below does this.
> 
> Tetsuo-san, when it comes to problems involving XFS, you should
> really CC xfs@oss.sgi.com because very few people really know how
> XFS works and even fewer still know how it is supposed to interact
> with memory reclaim....

Thank you for the patch, but ...

  #define PF_KSWAPD       0x00040000      /* I am kswapd */

  static inline int current_is_kswapd(void)
  {
  	return current->flags & PF_KSWAPD;
  }

I think ((char) (current->flags & 0x00040000)) == 0.
Your patch wants

  -args->kswapd = current_is_kswapd();
  +args->kswapd = (current_is_kswapd() != 0);
