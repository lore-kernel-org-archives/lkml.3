Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbaESRme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbaESRmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:42:33 -0400
Message-ID: <537A4282.804@redhat.com>
Date: Mon, 19 May 2014 13:42:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
In-Reply-To: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 10:40 AM, Tetsuo Handa wrote:
>>From f016db5d7f84d6321132150b13c5888ef67d694f Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 19 May 2014 23:24:11 +0900
> Subject: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
> 
> I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
> too many pages are isolated already" causes RHEL7 environment to stall with
> 0% CPU usage when a certain type of memory pressure is given.

> Since the kernel worker thread needs to escape from the while loop so that
> alloc_page() can allocate memory (and eventually allow xfs_vm_writepage()
> to release memory), I think that we should not block forever. This patch
> introduces 30 seconds timeout for userspace processes and 5 seconds timeout
> for kernel processes.

I suspect the fundamental problem is that other processes can
drive the system back to the limit, and unlucky processes can
end up starved forever.

This makes your fix (or something like it) necessary.

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
