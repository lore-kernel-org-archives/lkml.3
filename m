Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaBCXgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:36:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaBCXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:36:30 -0500
Date: Mon, 3 Feb 2014 15:36:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: hughd@google.com, "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/swap: prevent concurrent swapon on the same
 S_ISBLK blockdev
Message-Id: <20140203153628.5e186b0e4e81400773faa7ac@linux-foundation.org>
In-Reply-To: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com>
References: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 18:03:04 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> When swapon the same S_ISBLK blockdev concurrent, the allocated two
> swap_info could hold the same block_device, because claim_swapfile()
> allow the same holder(here, it is sys_swapon function).
> 
> To prevent this situation, This patch adds swap_lock protect to ensure
> we can find this situation and return -EBUSY for one swapon call.
> 
> As for S_ISREG swapfile, claim_swapfile() already prevent this scenario
> by holding inode->i_mutex.
> 
> This patch is just for a rare scenario, aim to correct of code.
> 

hm, OK.  Would it be saner to pass a unique `holder' to
claim_swapfile()?  Say, `p'?

Truly, I am fed up with silly swapon/swapoff races.  How often does
anyone call these things?  Let's slap a huge lock around the whole
thing and be done with it?

