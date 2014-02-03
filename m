Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaBCXXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:23:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCXXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:23:42 -0500
Date: Mon, 3 Feb 2014 15:23:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: hughd@google.com, "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/swap: fix race on swap_info reuse between
 swapoff and swapon
Message-Id: <20140203152340.b28bb35698ee75615eb23041@linux-foundation.org>
In-Reply-To: <000d01cf1b47$f12e11f0$d38a35d0$%yang@samsung.com>
References: <000d01cf1b47$f12e11f0$d38a35d0$%yang@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 18:03:04 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> swapoff clear swap_info's SWP_USED flag prematurely and free its resources
> after that. A concurrent swapon will reuse this swap_info while its previous
> resources are not cleared completely.
> 
> These late freed resources are:
>  - p->percpu_cluster
>  - swap_cgroup_ctrl[type]
>  - block_device setting
>  - inode->i_flags &= ~S_SWAPFILE
> 
> This patch clear SWP_USED flag after all its resources freed, so that swapon
> can reuse this swap_info by alloc_swap_info() safely.
> 
> This patch is just for a rare scenario, aim to correct of code.

I believe that
http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
makes this patch redundant?

