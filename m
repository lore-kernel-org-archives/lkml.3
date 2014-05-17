Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaEQAD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:03:27 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58623 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaEQADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:03:25 -0400
Message-ID: <1400285003.5367.17.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 3/8] list: Out of line INIT_LIST_HEAD and list_del
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Date: Fri, 16 May 2014 17:03:23 -0700
In-Reply-To: <1400276595-6965-4-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
	 <1400276595-6965-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 14:43 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Out of lining these two inlines saves ~21k on my vmlinux
> 
> 14152713	2003976	1507328	17664017	10d8811	vmlinux-before-list
> 14131431	2008136	1507328	17646895	10d452f	vmlinux-list
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

> +
> +void list_del(struct list_head *entry)
> +{
> +	__list_del(entry->prev, entry->next);
> +	entry->next = LIST_POISON1;
> +	entry->prev = LIST_POISON2;
> +}
> +EXPORT_SYMBOL(list_del);

Have you tried :

CONFIG_DEBUG_LIST=y

Function will be doubly defined/exported then....

BTW, my vmlinux is more like 

$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
8233991	1743032	1904640	11881663	 b54cbf	vmlinux

Seems I beat you without even trying ;)


