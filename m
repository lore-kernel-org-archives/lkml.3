Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbaFTIZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:25:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42523 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932937AbaFTIZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:25:49 -0400
Date: Fri, 20 Jun 2014 09:25:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM64: implement TASK_SIZE_OF
Message-ID: <20140620082520.GC25104@arm.com>
References: <1403122209-26352-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403122209-26352-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Wed, Jun 18, 2014 at 09:10:09PM +0100, Colin Cross wrote:
> include/linux/sched.h implements TASK_SIZE_OF as TASK_SIZE if it
> is not set by the architecture headers.  TASK_SIZE uses the
> current task to determine the size of the virtual address space.
> On a 64-bit kernel this will cause reading /proc/pid/pagemap of a
> 64-bit process from a 32-bit process to return EOF when it reads
> past 0xffffffff.
> 
> Implement TASK_SIZE_OF exactly the same as TASK_SIZE with
> test_tsk_thread_flag instead of test_thread_flag.

Looks sane to me.

  Acked-by: Will Deacon <will.deacon@arm.com>

I take it you're being bitten by this in real software, hence the CC stable
tag?

Will
