Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3JMSCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:02:33 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53002 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab3JMSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:02:32 -0400
Date: Sun, 13 Oct 2013 14:02:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: yinghai@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 07/23] mm/memblock: debug: correct displaying of upper
 memory boundary
Message-ID: <20131013180227.GD5253@mtj.dyndns.org>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
 <1381615146-20342-8-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381615146-20342-8-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 05:58:50PM -0400, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> When debugging is enabled (cmdline has "memblock=debug") the memblock
> will display upper memory boundary per each allocated/freed memory range
> wrongly. For example:
>  memblock_reserve: [0x0000009e7e8000-0x0000009e7ed000] _memblock_early_alloc_try_nid_nopanic+0xfc/0x12c
> 
> The 0x0000009e7ed000 is displayed instead of 0x0000009e7ecfff
> 
> Hence, correct this by changing formula used to calculate upper memory
> boundary to (u64)base + size - 1 instead of  (u64)base + size everywhere
> in the debug messages.

I kinda prefer base + size because it's easier to actually know the
size but yeah, it should have been [base, base + size) and other
places use base + size - 1 notation so it probably is better to stick
to that.  Maybe move this one to the beginning of the series?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
