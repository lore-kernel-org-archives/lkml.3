Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaCKE5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:57:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaCKE5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:57:33 -0400
Date: Mon, 10 Mar 2014 22:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-Id: <20140310220158.7e8b7f2a.akpm@linux-foundation.org>
In-Reply-To: <20140311045109.GB12551@redhat.com>
References: <20140305174503.GA16335@redhat.com>
	<20140305175725.GB16335@redhat.com>
	<20140307002210.GA26603@redhat.com>
	<20140311024906.GA9191@redhat.com>
	<20140310201340.81994295.akpm@linux-foundation.org>
	<20140310214612.3b4de36a.akpm@linux-foundation.org>
	<20140311045109.GB12551@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 00:51:09 -0400 Dave Jones <davej@redhat.com> wrote:

> On Mon, Mar 10, 2014 at 09:46:12PM -0700, Andrew Morton wrote:
>  > On Mon, 10 Mar 2014 20:13:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>  > 
>  > > > Anyone ? I'm hitting this trace on an almost daily basis, which is a pain
>  > > > while trying to reproduce a different bug..
>  > > 
>  > > Damn, I thought we'd fixed that but it seems not.  Cc's added.
>  > > 
>  > > Guys, what stops the migration target page from coming unlocked in
>  > > parallel with zap_pte_range()'s call to migration_entry_to_page()?
>  > 
>  > page_table_lock, sort-of.  At least, transitions of is_migration_entry()
>  > and page_locked() happen under ptl.
>  > 
>  > I don't see any holes in regular migration.  Do you know if this is
>  > reproducible with CONFIG_NUMA_BALANCING=n or CONFIG_NUMA=n?
> 
> CONFIG_NUMA_BALANCING was n already btw, so I'll do a NUMA=n run.

There probably isn't much point unless trinity is using
sys_move_pages().  Is it?  If so it would be interesting to disable
trinity's move_pages calls and see if it still fails.

Grasping at straws here, trying to reduce the amount of code to look at :(
