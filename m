Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaCKM4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:56:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29947 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaCKM4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:56:05 -0400
Message-ID: <531F07D4.5000108@oracle.com>
Date: Tue, 11 Mar 2014 08:55:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
References: <20140305174503.GA16335@redhat.com> <20140305175725.GB16335@redhat.com> <20140307002210.GA26603@redhat.com> <20140311024906.GA9191@redhat.com> <20140310201340.81994295.akpm@linux-foundation.org> <20140310214612.3b4de36a.akpm@linux-foundation.org> <20140311045109.GB12551@redhat.com> <20140310220158.7e8b7f2a.akpm@linux-foundation.org> <20140311053017.GB14329@redhat.com>
In-Reply-To: <20140311053017.GB14329@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 01:30 AM, Dave Jones wrote:
> On Mon, Mar 10, 2014 at 10:01:58PM -0700, Andrew Morton wrote:
>   > On Tue, 11 Mar 2014 00:51:09 -0400 Dave Jones <davej@redhat.com> wrote:
>   >
>   > > On Mon, Mar 10, 2014 at 09:46:12PM -0700, Andrew Morton wrote:
>   > >  > On Mon, 10 Mar 2014 20:13:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>   > >  >
>   > >  > > > Anyone ? I'm hitting this trace on an almost daily basis, which is a pain
>   > >  > > > while trying to reproduce a different bug..
>   > >  > >
>   > >  > > Damn, I thought we'd fixed that but it seems not.  Cc's added.
>   > >  > >
>   > >  > > Guys, what stops the migration target page from coming unlocked in
>   > >  > > parallel with zap_pte_range()'s call to migration_entry_to_page()?
>   > >  >
>   > >  > page_table_lock, sort-of.  At least, transitions of is_migration_entry()
>   > >  > and page_locked() happen under ptl.
>   > >  >
>   > >  > I don't see any holes in regular migration.  Do you know if this is
>   > >  > reproducible with CONFIG_NUMA_BALANCING=n or CONFIG_NUMA=n?
>   > >
>   > > CONFIG_NUMA_BALANCING was n already btw, so I'll do a NUMA=n run.
>   >
>   > There probably isn't much point unless trinity is using
>   > sys_move_pages().  Is it?  If so it would be interesting to disable
>   > trinity's move_pages calls and see if it still fails.
>
> Ok, with move_pages excluded it still oopses.

FWIW, yes - I still see both of these issues happening. It's easy to ignore the
bad rss-counter, and I've commented out the BUG at swapops.h so that I could keep
on testing.

There are quite a few issues within mm/ right now, I think there are more than 5
different BUG()s hittable using trinity at this point without a fix.


Thanks,
Sasha

