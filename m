Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3J1CDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:03:02 -0400
Received: from trent.utfs.org ([94.185.90.103]:42770 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab3J1CDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:03:00 -0400
Date: Sun, 27 Oct 2013 19:02:49 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: mmarek@suse.cz, yann.morin.1998@free.fr, akpm@linux-foundation.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: Re: [PATCH] scripts/kconfig/menu.c: warning: jump may be used
 uninitialized in this function
In-Reply-To: <alpine.DEB.2.11.1310271822540.31521@trent.utfs.org>
Message-ID: <alpine.DEB.2.11.1310271859320.31521@trent.utfs.org>
References: <alpine.DEB.2.11.1310271822540.31521@trent.utfs.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 at 18:28, Christian Kujau wrote:
> While doing "make oldconfig" on 3.12-rc7 with gcc-4.7.2 (Debian), the 
> following warning is printed:
> 
>   HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> /usr/local/src/linux-git/scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> /usr/local/src/linux-git/scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> /usr/local/src/linux-git/scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here

Grrr, only after I sent this message I found this was reported in 
September already by Madhavan Srinivasan:  https://lkml.org/lkml/2013/9/19/24

Does anybody know the state of this fix?

Thanks,
Christian.

> The following patch seems to fix that:
> 
>  Signed-off-by: Christian Kujau <lists@nerdbynature.de>
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index c1d5320..23b1827 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -544,7 +544,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  {
>  	int i, j;
>  	struct menu *submenu[8], *menu, *location = NULL;
> -	struct jump_key *jump;
> +	struct jump_key *jump = NULL;
>  
>  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>  	menu = prop->menu->parent;
> 
> 
> Christian.
> -- 
> BOFH excuse #177:
> 
> sticktion
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
BOFH excuse #449:

greenpeace free'd the mallocs
