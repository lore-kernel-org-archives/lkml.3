Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaGaUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:16:13 -0400
Received: from orange.myspectrum.nl ([149.210.134.247]:50621 "EHLO
	orange.myspectrum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaGaUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:16:10 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2014 16:16:10 EDT
Message-ID: <53DAA2A0.3050205@myspectrum.nl>
Date: Thu, 31 Jul 2014 22:10:08 +0200
From: Jeroen Hofstee <dasuboot@myspectrum.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>, u-boot@lists.denx.de
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [U-Boot] [PATCH] kconfig: Fix compiler warning in menu.c
References: <1406816503-31963-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1406816503-31963-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

On 31-07-14 16:21, Hans de Goede wrote:
> This fixes the following compiler warning:
>
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       jump->offset = strlen(r->s);
>                    ^
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>    struct jump_key *jump;
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

just curious, which compiler is this? Since it is a false positive.
(and it could know)

Regards,
Jeroen
