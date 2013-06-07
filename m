Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3FGOQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:16:17 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:51607 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab3FGOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:16:13 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51B1EB25.9000509@yandex-team.ru>
Date: Fri, 07 Jun 2013 18:16:05 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        metin d <metdos@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 09/10] mm: thrash detection-based file cache sizing
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org> <1369937046-27666-10-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1369937046-27666-10-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.05.2013 22:04, Johannes Weiner wrote:
> +/*
> + * Monotonic workingset clock for non-resident pages.
> + *
> + * The refault distance of a page is the number of ticks that occurred
> + * between that page's eviction and subsequent refault.
> + *
> + * Every page slot that is taken away from the inactive list is one
> + * more slot the inactive list would have to grow again in order to
> + * hold the current non-resident pages in memory as well.
> + *
> + * As the refault distance needs to reflect the space missing on the
> + * inactive list, the workingset time is advanced every time the
> + * inactive list is shrunk.  This means eviction, but also activation.
> + */
> +static atomic_long_t workingset_time;

It seems strange to me, that workingset_time is global.
Don't you want to make it per-cgroup?

Two more questions:
1) do you plan to take fadvise's into account somehow?
2) do you plan to use workingset information to enhance
	the readahead mechanism?

Thanks!

Regards,
Roman
