Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3GXSwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:52:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:60732 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3GXSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:52:44 -0400
Message-ID: <51F02273.1050308@parallels.com>
Date: Wed, 24 Jul 2013 22:52:35 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
References: <20130724160826.GD24851@moon>
In-Reply-To: <20130724160826.GD24851@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 08:08 PM, Cyrill Gorcunov wrote:
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
> 
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
