Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3IZRFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:05:31 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60389 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IZRF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:05:28 -0400
Date: Thu, 26 Sep 2013 19:05:20 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: mmarek@suse.cz, bpoirier@suse.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] kconfig/menu.c: fix uninitialized variable warning
Message-ID: <20130926170520.GB3418@free.fr>
References: <1379869557-23116-1-git-send-email-maddy@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1379869557-23116-1-git-send-email-maddy@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Madhavan, All,

On 2013-09-22 22:35 +0530, Madhavan Srinivasan spake thusly:
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
>      jump->offset = r->len - 1;
>                   ^
> scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
>   struct jump_key *jump;
>                    ^
> Change V2:
> 
> 1)Added comment as suggested.

Maybe I'm mislead, but I think Benjamin and I suggested a comment that
explained the warning was just spurious, and there would be no code
change. Something like:

    /* gcc 4.8.0 on (your distro and version) warns about 'jump may be
     * used uninitialized', which is wrong. The warning does not appear
     * with gcc != 4.8.0 */
    struct jump_key *jump;

This is so, if sometime in the future the code changes, and the variable
is indeeded used uninitialised, we have a proper warning by gcc in this
case.

Care to resend, please?

Regards,
Yann E. MORIN.

> Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> ---
>  scripts/kconfig/menu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index c1d5320..32ee2d5 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -544,7 +544,8 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  {
>  	int i, j;
>  	struct menu *submenu[8], *menu, *location = NULL;
> -	struct jump_key *jump;
> +	/* Initializing to avoid a spurious warning observed in gcc 4.8.0 */
> +	struct jump_key *jump = NULL;
>  
>  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>  	menu = prop->menu->parent;
> -- 
> 1.7.10.4
> 

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
