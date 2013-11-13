Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3KMMMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:12:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:39172 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab3KMMMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:12:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,692,1378882800"; 
   d="scan'208";a="426840516"
Date: Wed, 13 Nov 2013 20:11:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] block: Employ u64_stats_init()
Message-ID: <20131113121145.GA22849@localhost>
References: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:42:14PM -0800, John Stultz wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Now that seqcounts are lockdep enabled objects, we need to properly
> initialize them.

It works!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

/kernel/i386-randconfig-j7-11082318/cb460d7163af828b404eeb6e06cb236895e7edd6

+-------------------------------------------------+-------+--------------+--------------+
|                                                 | v3.12 | 838cc7b488f8 | cb460d7163af |
+-------------------------------------------------+-------+--------------+--------------+
| boot_successes                                  | 129   | 0            | 100          |
| boot_failures                                   | 1     | 100          |              |
| BUG:kernel_early_hang_without_any_printk_output | 1     |              |              |
| INFO:trying_to_register_non-static_key          | 0     | 100          |              |
+-------------------------------------------------+-------+--------------+--------------+

Thanks,
Fengguang
