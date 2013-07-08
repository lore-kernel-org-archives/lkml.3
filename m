Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3GHLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3GHLZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:25:39 -0400
Subject: Re: [PATCH 13/15] kconfig/[mn]conf: make it explicit in the search
 box that a regexp is possible
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <a1ce636f560336ba007bfabb15b167ff31b592cf.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	 <a1ce636f560336ba007bfabb15b167ff31b592cf.1372097219.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 08 Jul 2013 13:25:24 +0200
Message-ID: <1373282724.4298.203.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/mconf.c | 2 +-
>  scripts/kconfig/nconf.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 6ee4aae..18d3dc9 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -401,7 +401,7 @@ static void search_conf(void)
>  	struct subtitle_part stpart;
>  
>  	title = str_new();
> -	str_printf( &title, _("Enter %s (sub)string to search for "
> +	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
>  			      "(with or without \"%s\")"), CONFIG_, CONFIG_);

While clearer, this also makes the title span over two lines when it
used to fit on a single one. I would like to suggest the following:

	str_printf(&title, _("Enter (sub)string or regexp to search for "
			     "(with or without \"%s\")"), CONFIG_);

Rationale: the "(with or without CONFIG_)" makes things clear enough
IMHO, making the first occurrence redundant.

But if you don't like this proposal then let's just go with yours, it's
up to you.

>  
>  again:
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index 0183153..7975d8d 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -695,7 +695,7 @@ static void search_conf(void)
>  	int dres;
>  
>  	title = str_new();
> -	str_printf( &title, _("Enter %s (sub)string to search for "
> +	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
>  			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
>  
>  again:


-- 
Jean Delvare
Suse L3

