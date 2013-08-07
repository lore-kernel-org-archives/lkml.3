Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3HGUV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:21:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3HGUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:21:57 -0400
Date: Wed, 7 Aug 2013 13:21:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        gorcunov@openvz.org, xemul@parallels.com, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] [PATCH] mm: Save soft-dirty bits on swapped pages
Message-Id: <20130807132156.e97bbcc3d543cf88d5a0997d@linux-foundation.org>
In-Reply-To: <20130730204654.844299768@gmail.com>
References: <20130730204154.407090410@gmail.com>
	<20130730204654.844299768@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013 00:41:55 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Andy Lutomirski reported that in case if a page with _PAGE_SOFT_DIRTY
> bit set get swapped out, the bit is getting lost and no longer
> available when pte read back.
> 
> To resolve this we introduce _PTE_SWP_SOFT_DIRTY bit which is
> saved in pte entry for the page being swapped out. When such page
> is to be read back from a swap cache we check for bit presence
> and if it's there we clear it and restore the former _PAGE_SOFT_DIRTY
> bit back.
> 
> One of the problem was to find a place in pte entry where we can
> save the _PTE_SWP_SOFT_DIRTY bit while page is in swap. The
> _PAGE_PSE was chosen for that, it doesn't intersect with swap
> entry format stored in pte.

So the implication is that if another architecture wants to support
this (and, realistically, wants to support CRIU), that architecture
must find a spare pte bit to implement _PTE_SWP_SOFT_DIRTY.  Yes?

