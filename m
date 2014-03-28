Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaC1OdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaC1OdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:33:04 -0400
Message-ID: <533587FD.7000006@redhat.com>
Date: Fri, 28 Mar 2014 10:32:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>
CC: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Bob Liu <bob.liu@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Adding compression before/above swapcache
References: <CALZtONDiOdYSSu02Eo78F4UL5OLTsk-9MR1hePc-XnSujRuvfw@mail.gmail.com> <20140327222605.GB16495@medulla.variantweb.net> <CALZtONDBNzL_S+UUxKgvNjEYu49eM5Fc2yJ37dJ8E+PEK+C7qg@mail.gmail.com>
In-Reply-To: <CALZtONDBNzL_S+UUxKgvNjEYu49eM5Fc2yJ37dJ8E+PEK+C7qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 08:36 AM, Dan Streetman wrote:

> Well my general idea was to modify shrink_page_list() so that instead
> of calling add_to_swap() and then pageout(), anonymous pages would be
> added to a compressed cache.  I haven't worked out all the specific
> details, but I am initially thinking that the compressed cache could
> simply repurpose incoming pages to use as the compressed cache storage
> (using its own page mapping, similar to swap page mapping), and then
> add_to_swap() the storage pages when the compressed cache gets to a
> certain size.  Pages that don't compress well could just bypass the
> compressed cache, and get sent the current route directly to
> add_to_swap().

That sounds a lot like what zswap does. How is your
proposal different?

And, is there an easier way to implement that difference? :)


