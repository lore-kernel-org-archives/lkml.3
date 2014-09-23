Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaIWEpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:45:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39490 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaIWEpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:45:15 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 23 Sep 2014 13:45:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com
Subject: Re: [PATCH v1 2/5] mm: add full variable in swap_info_struct
Message-ID: <20140923044551.GB8325@bbox>
References: <1411344191-2842-1-git-send-email-minchan@kernel.org>
 <1411344191-2842-3-git-send-email-minchan@kernel.org>
 <20140922134522.00725f561fdae318446a41cb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140922134522.00725f561fdae318446a41cb@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:45:22PM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2014 09:03:08 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Now, swap leans on !p->highest_bit to indicate a swap is full.
> > It works well for normal swap because every slot on swap device
> > is used up when the swap is full but in case of zram, swap sees
> > still many empty slot although backed device(ie, zram) is full
> > since zram's limit is over so that it could make trouble when
> > swap use highest_bit to select new slot via free_cluster.
> > 
> > This patch introduces full varaiable in swap_info_struct
> > to solve the problem.
> > 
> > ...
> >
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -224,6 +224,7 @@ struct swap_info_struct {
> >  	struct swap_cluster_info free_cluster_tail; /* free cluster list tail */
> >  	unsigned int lowest_bit;	/* index of first free in swap_map */
> >  	unsigned int highest_bit;	/* index of last free in swap_map */
> > +	bool	full;			/* whether swap is full or not */
> 
> This is protected by swap_info_struct.lock, I worked out.
> 
> There's a large comment at swap_info_struct.lock which could be updated.

Sure.

-- 
Kind regards,
Minchan Kim
