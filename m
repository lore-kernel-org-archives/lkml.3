Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3BSS5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:57:12 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54947 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab3BSS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:57:08 -0500
Date: Tue, 19 Feb 2013 10:56:27 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ric Mason <ric.masonn@gmail.com>
cc: Li Haifeng <omycle@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Should a swapped out page be deleted from swap cache?
In-Reply-To: <512338A6.1030602@gmail.com>
Message-ID: <alpine.LNX.2.00.1302191050330.2248@eggly.anvils>
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com> <alpine.LNX.2.00.1302180939200.2246@eggly.anvils> <512338A6.1030602@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Ric Mason wrote:
> 
> There is a call of try_to_free_swap in function swap_writepage, if
> swap_writepage is call from shrink_page_list path, PageSwapCache(page) ==
> trure, PageWriteback(page) maybe false, page_swapcount(page) == 0, then will
> delete the page from swap cache and free swap slot, where I miss?

That's correct.  PageWriteback is sure to be false there.  page_swapcount
usually won't be 0 there, but sometimes it will be, and in that case we
do want to delete from swap cache and free the swap slot.

Hugh
