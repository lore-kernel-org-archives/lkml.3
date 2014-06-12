Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaFLTZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:25:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaFLTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:25:48 -0400
Date: Thu, 12 Jun 2014 12:25:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] mm: Move __vma_address() to internal.h to be inlined in
 huge_memory.c
Message-Id: <20140612122546.cfdebdb22bb22c0f767e30b5@linux-foundation.org>
In-Reply-To: <1402600540-52031-1-git-send-email-Waiman.Long@hp.com>
References: <1402600540-52031-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014 15:15:40 -0400 Waiman Long <Waiman.Long@hp.com> wrote:

> The vma_address() function which is used to compute the virtual address
> within a VMA is used only by 2 files in the mm subsystem - rmap.c and
> huge_memory.c. This function is defined in rmap.c and is inlined by
> its callers there, but it is also declared as an external function.
> 
> However, the __split_huge_page() function which calls vma_address()
> in huge_memory.c is calling it as a real function call. This is not
> as efficient as an inlined function. This patch moves the underlying
> inlined __vma_address() function to internal.h to be shared by both
> the rmap.c and huge_memory.c file.

This increases huge_memory.o's text+data_bss by 311 bytes, which makes
me suspect that it is a bad change due to its increase of kernel cache
footprint.

Perhaps we should be noinlining __vma_address()?
