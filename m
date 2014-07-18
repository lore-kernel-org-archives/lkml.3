Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbaGRPM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:12:59 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46506 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:12:58 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140718144554.GG29639@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
	<1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
	<20140715082545.GA9366@dhcp22.suse.cz>
	<20140715121935.GB9366@dhcp22.suse.cz>
	<20140718071246.GA21565@dhcp22.suse.cz>
	<20140718144554.GG29639@cmpxchg.org>
Date: Fri, 18 Jul 2014 17:12:54 +0200
Message-ID: <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
From: Miklos Szeredi <miklos@szeredi.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 4:45 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:

> I assumed the source page would always be new, according to this part
> in fuse_try_move_page():
>
>         /*
>          * This is a new and locked page, it shouldn't be mapped or
>          * have any special flags on it
>          */
>         if (WARN_ON(page_mapped(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(page_has_private(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
>                 goto out_fallback_unlock;
>         if (WARN_ON(PageMlocked(oldpage)))
>                 goto out_fallback_unlock;
>
> However, it's in the page cache and I can't really convince myself
> that it's not also on the LRU.  Miklos, I have trouble pinpointing
> where oldpage is instantiated exactly and what state it might be in -
> can it already be on the LRU?

oldpage comes from ->readpages() (*NOT* ->readpage()), i.e. readahead.

AFAICS it is added to the LRU in read_cache_pages(), so it looks like
it is definitely on the LRU at that point.

Thanks,
Miklos
