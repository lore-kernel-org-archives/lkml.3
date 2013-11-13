Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab3KMRlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:41:10 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38007 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3KMRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:40:53 -0500
Message-ID: <5283B9A0.2080502@linaro.org>
Date: Wed, 13 Nov 2013 09:40:48 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: performance regressions by "seqcount: Add lockdep functionality
 to seqcount/seqlock structures"
References: <20131113091408.GH22256@yliu-dev.sh.intel.com>
In-Reply-To: <20131113091408.GH22256@yliu-dev.sh.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 01:14 AM, Yuanhan Liu wrote:
> Hi,
>
> FYI, we found some performance regressions caused by commit 1ca7d67c
> ("seqcount: Add lockdep functionality to seqcount/seqlock structures")

So this is expected. seqlock readers are usually very very cheap
operations, and we're now doing lockdep tracking on every iteration
around the loop. As the lockdep help states:

  | If you say Y here, the lock dependency engine will
do                   |  
  | additional runtime checks to debug itself, at the
price                 |  
  | of more runtime overhead.


So now since we're also tracking seqlocks in addition to spinlocks, it
creates more overhead.


Disabling CONFIG_LOCKDEP should restore performance.

thanks
-john

