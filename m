Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbaELN5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:57:25 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:38488
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758173AbaELN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:57:24 -0400
Date: Mon, 12 May 2014 08:57:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org,
        riel@redhat.com, minchan@kernel.org, zhangyanfei@cn.fujitsu.com,
        hanpt@linux.vnet.ibm.com, sasha.levin@oracle.com, oleg@redhat.com,
        fabf@skynet.be, mgorman@suse.de, aarcange@redhat.com, cldu@marvell.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: use a irq-safe __mod_zone_page_state in
 mlocked_vma_newpage()
In-Reply-To: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1405120855470.3090@gentwo.org>
References: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Jianyu Zhan wrote:

> mlocked_vma_newpage() is only called in fault path by
> page_add_new_anon_rmap(), which is called on a *new* page.
> And such page is initially only visible via the pagetables, and the
> pte is locked while calling page_add_new_anon_rmap(), so we need not
> use an irq-safe mod_zone_page_state() here, using a light-weight version
> __mod_zone_page_state() would be OK.

This has nothing to do with the safety of statistics operations that work
on different data structures. Which leads to the conclusion that
__mod_page_state cannot be used here.


