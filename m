Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbaEIP4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:56:25 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:52035 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837AbaEIP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:56:23 -0400
Date: Fri, 9 May 2014 10:56:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz, aarcange@redhat.com, hanpt@linux.vnet.ibm.com,
        mgorman@suse.de, oleg@redhat.com, cldu@marvell.com, fabf@skynet.be,
        sasha.levin@oracle.com, zhangyanfei@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: use a irq-safe __mod_zone_page_state in
 mlocked_vma_newpage()
In-Reply-To: <1399648668-17420-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1405091050520.11318@gentwo.org>
References: <1399648668-17420-1-git-send-email-nasa4836@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 May 2014, Jianyu Zhan wrote:

> mlocked_vma_newpage() is only called in fault path by
> page_add_new_anon_rmap(), which is called on a *new* page.
> And such page is initially only visible via the pagetables, and the
> pte is locked while calling page_add_new_anon_rmap(), so we could use
> a irq-safe version of __mod_zone_page_state() here.

You are changing from the irq safe variant to __mod_zone_page_state which
is *not* irq safe. Its legit to do so since presumably irqs are disabled
anyways so you do not have to worry about irq safeness of
__mod_zone_page_state.

Please update the description. Its a bit confusing right now.
