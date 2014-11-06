Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaKFMgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:36:36 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57583 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbaKFMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:36:35 -0500
Message-ID: <1415277392.4390.29.camel@x220>
Subject: Re: [PATCH] kconfig: Fix warning
 =?UTF-8?Q?=22=E2=80=98jump=E2=80=99?= may be used uninitialized"
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter =?ISO-8859-1?Q?K=FCmmel?= <syntheticpp@gmx.net>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 06 Nov 2014 13:36:32 +0100
In-Reply-To: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
References: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Nov 2014 12:36:33.0669 (UTC) FILETIME=[4C53B350:01CFF9BE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 13:03 +0100, Peter Kümmel wrote:
> Warning:
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      jump->offset = strlen(r->s);
> 
> Simplifies the test logic because (head && local) means (jump != 0)
> and makes GCC happy when checking if the jump pointer was initialized.
> 
> Signed-off-by: Peter Kümmel <syntheticpp@gmx.net>
> ---

Is this patch and the three others patches you just sent identical (or
not) to the four patches you sent yesterday and the day before yesterday
to linux-kbuild and Yann Morin? Either way, why are you posting them to
lkml now?

>  scripts/kconfig/menu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index a26cc5d..72c9dba 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  {
>  	int i, j;
>  	struct menu *submenu[8], *menu, *location = NULL;
> -	struct jump_key *jump;
> +	struct jump_key *jump = NULL;
>  
>  	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>  	menu = prop->menu->parent;
> @@ -586,7 +586,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  		str_printf(r, _("  Location:\n"));
>  		for (j = 4; --i >= 0; j += 2) {
>  			menu = submenu[i];
> -			if (head && location && menu == location)
> +			if (jump && menu == location)
>  				jump->offset = strlen(r->s);
>  			str_printf(r, "%*c-> %s", j, ' ',
>  				   _(menu_get_prompt(menu)));


