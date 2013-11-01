Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3KATBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:01:55 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38609 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3KATBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:01:54 -0400
Message-ID: <5273FA9D.7010006@gmail.com>
Date: Fri, 01 Nov 2013 15:01:49 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org
CC: kosaki.motohiro@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/1/13 3:54 AM), Yuanhan Liu wrote:
> Patch 1 turns locking the anon_vma's root to locking itself to let it be
> a per anon_vma lock, which would reduce contentions.
> 
> In the same time, lock range becomes quite small then, which is bascially
> a call of anon_vma_interval_tree_insert(). Patch 2 turn rwsem to rwlock_t.
> It's a patch made from Ingo, I just made some change to let it apply based on
> patch 1.
> 
> Patch 3 is from Peter. It was a diff, I edited it to be a patch ;)
> 
> Here is the detailed changed stats with this patch applied. The test base is v3.12-rc7,
> and 1c00bef768d4341afa7d is patch 1, e3e37183ee805f33e88f is patch 2.
> 
> NOTE: both commits are compared to base v3.12-rc7.

I'd suggest you CCing linux-mm when posting mm patches.

