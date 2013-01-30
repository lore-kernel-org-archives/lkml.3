Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3A3Xr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:47:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab3A3Xr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:47:27 -0500
Date: Wed, 30 Jan 2013 15:47:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hlist: drop the node parameter from iterators
Message-Id: <20130130154725.f7b40daa.akpm@linux-foundation.org>
In-Reply-To: <5108728E.5020901@oracle.com>
References: <1358998645-20452-1-git-send-email-sasha.levin@oracle.com>
	<5108728E.5020901@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 20:08:30 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> Also, ping :)
>
> ...
>
> >  216 files changed, 1031 insertions(+), 1526 deletions(-)

Whimper.

I don't really see a sane way of avoiding a single huge atomic smash
here.  Normally we'd use a multistep process:

1: Create a new and differently named macro, say "sasha_is_a_pita()".

2: Convert hlist_for_each_entry() to sasha_is_a_pita() in as many
   sites as we can.

3: Once we think all sites are converted, delete the now-unused
   hlist_for_each_entry() definition.

Problem is, there just isn't any other identifier we can use here apart
from hlist_for_each_entry().

I suppose we could add additional steps:

4: Add hlist_for_each_entry(), which is identical to sasha_is_a_pita().

5: Convert sasha_is_a_pita() to hlist_for_each_entry() in as many
   sites as we can.

6: Once we think all sites are converted, delete the now-unused
   sasha_is_a_pita() definition.

But geeze.


The alternative is to do the huge atomic smash immediately after the
3.9-rc1 release, when the amount of pending out-of-tree code is at a
minimum.

