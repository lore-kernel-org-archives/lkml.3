Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaIVUpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:45:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaIVUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:45:24 -0400
Date: Mon, 22 Sep 2014 13:45:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com
Subject: Re: [PATCH v1 2/5] mm: add full variable in swap_info_struct
Message-Id: <20140922134522.00725f561fdae318446a41cb@linux-foundation.org>
In-Reply-To: <1411344191-2842-3-git-send-email-minchan@kernel.org>
References: <1411344191-2842-1-git-send-email-minchan@kernel.org>
	<1411344191-2842-3-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 09:03:08 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Now, swap leans on !p->highest_bit to indicate a swap is full.
> It works well for normal swap because every slot on swap device
> is used up when the swap is full but in case of zram, swap sees
> still many empty slot although backed device(ie, zram) is full
> since zram's limit is over so that it could make trouble when
> swap use highest_bit to select new slot via free_cluster.
> 
> This patch introduces full varaiable in swap_info_struct
> to solve the problem.
> 
> ...
>
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -224,6 +224,7 @@ struct swap_info_struct {
>  	struct swap_cluster_info free_cluster_tail; /* free cluster list tail */
>  	unsigned int lowest_bit;	/* index of first free in swap_map */
>  	unsigned int highest_bit;	/* index of last free in swap_map */
> +	bool	full;			/* whether swap is full or not */

This is protected by swap_info_struct.lock, I worked out.

There's a large comment at swap_info_struct.lock which could be updated.


