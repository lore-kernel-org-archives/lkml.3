Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaF3RCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:02:52 -0400
Received: from mout.gmx.net ([212.227.15.18]:49663 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaF3RCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:02:49 -0400
Message-ID: <53B1982F.4030504@gmx.de>
Date: Mon, 30 Jun 2014 19:02:39 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] script/kconfig: remove a warning for menucofig
References: <1404098187-9638-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1404098187-9638-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:rI86fz+BfqLnBPxZdqGjOuAqFiKO5IB/1LxMIcCanlDF7D3n5Sg
 VKKUUaKQqF1bq7WkkPLl/InGmMXx5eaDpKtURGj/M2BhB0NDH9vcneRFo7jC+o2q96ekR1x
 KARZfNTASYvd3oBc1nYT/h8wW04J4JF6CdUX7z96zxiKlnqoZLrJHVNlXjmvErZniDHAMw/
 F/yErfDHOV7p6N68tM+KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.06.2014 05:16, Li, Zhen-Hua wrote:
> There is a warning when run "make menuconfig".
>
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:591:18: warning: ‘jump’ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
>       jump->offset = strlen(r->s);
>                    ^
> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>    struct jump_key *jump;
>                     ^
>
> It is because the compiler think "jump" is not initialized, though in fact
> it is already initialized.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   scripts/kconfig/menu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index a26cc5d..584e0fc 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>   {
>   	int i, j;
>   	struct menu *submenu[8], *menu, *location = NULL;
> -	struct jump_key *jump;
> +	struct jump_key *jump = NULL;
>
>   	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>   	menu = prop->menu->parent;
>
Hello Zhen-Hua,

the patch looks incomplete to me. A check
jump != NULL
should be added before accessing parts of structure jump_key.

Best regards

Heinrich Schuchardt
