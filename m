Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaFWLNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:13:51 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40102 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752443AbaFWLNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:13:50 -0400
Date: Mon, 23 Jun 2014 12:13:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM64: implement TASK_SIZE_OF
Message-ID: <20140623111343.GC15907@arm.com>
References: <1403122209-26352-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403122209-26352-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Colin Cross <ccross@android.com>

Thanks. Applied.

-- 
Catalin
