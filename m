Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaC1OsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:48:01 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64214 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaC1OsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <533587FD.7000006@redhat.com>
References: <CALZtONDiOdYSSu02Eo78F4UL5OLTsk-9MR1hePc-XnSujRuvfw@mail.gmail.com>
 <20140327222605.GB16495@medulla.variantweb.net> <CALZtONDBNzL_S+UUxKgvNjEYu49eM5Fc2yJ37dJ8E+PEK+C7qg@mail.gmail.com>
 <533587FD.7000006@redhat.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Fri, 28 Mar 2014 10:47:38 -0400
X-Google-Sender-Auth: ljsKhRks4F9RSYXIZtpt5d14yPo
Message-ID: <CALZtONA=v+3_+6qEvyY0SruT=aGxAfV_N5fsHvLMJKFp4Stnww@mail.gmail.com>
Subject: Re: Adding compression before/above swapcache
To: Rik van Riel <riel@redhat.com>
Cc: Seth Jennings <sjennings@variantweb.net>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 10:32 AM, Rik van Riel <riel@redhat.com> wrote:
> On 03/28/2014 08:36 AM, Dan Streetman wrote:
>
>> Well my general idea was to modify shrink_page_list() so that instead
>> of calling add_to_swap() and then pageout(), anonymous pages would be
>> added to a compressed cache.  I haven't worked out all the specific
>> details, but I am initially thinking that the compressed cache could
>> simply repurpose incoming pages to use as the compressed cache storage
>> (using its own page mapping, similar to swap page mapping), and then
>> add_to_swap() the storage pages when the compressed cache gets to a
>> certain size.  Pages that don't compress well could just bypass the
>> compressed cache, and get sent the current route directly to
>> add_to_swap().
>
>
> That sounds a lot like what zswap does. How is your
> proposal different?

Two main ways:
1) it's above swap, so it would still work without any real swap.
2) compressed pages could be written to swap disk.

Essentially, the two existing memory compression approaches are both
tied to swap.  But, AFAIK there's no reason that memory compression
has to be tied to swap.  So my approach uncouples it.

>
> And, is there an easier way to implement that difference? :)

I'm hoping that it wouldn't actually be too complex.  But that's part
of why I emailed for feedback before digging into a prototype... :-)


>
>
