Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3D2T2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:28:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:37212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab3D2T2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:28:46 -0400
Message-ID: <517EC9C7.9000903@infradead.org>
Date: Mon, 29 Apr 2013 12:28:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: Re: [PATCH 1/1] kconfig: fix lists definition for C++
References: <cover.1367258255.git.yann.morin.1998@free.fr> <21ca352b71ca252e1933b1538fe89da8a04395c3.1367258255.git.yann.morin.1998@free.fr>
In-Reply-To: <21ca352b71ca252e1933b1538fe89da8a04395c3.1367258255.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 10:59, Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> The C++ compiler is more strict in that it refuses to assign
> a void* to a struct list_head*.
> 
> Fix that by explicitly casting the poisonning constants.
> 
> (Tested with all 5 frontends, now.)
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Benjamin Poirier <bpoirier@suse.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  scripts/kconfig/list.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
> index ea1d581..685d80e 100644
> --- a/scripts/kconfig/list.h
> +++ b/scripts/kconfig/list.h
> @@ -125,7 +125,7 @@ static inline void __list_del(struct list_head *prev, struct list_head *next)
>  static inline void list_del(struct list_head *entry)
>  {
>  	__list_del(entry->prev, entry->next);
> -	entry->next = LIST_POISON1;
> -	entry->prev = LIST_POISON2;
> +	entry->next = (struct list_head*)LIST_POISON1;
> +	entry->prev = (struct list_head*)LIST_POISON2;
>  }
>  #endif
> 


-- 
~Randy
