Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbaF3XLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:11:40 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5646 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaF3XLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:11:38 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] script/kconfig: remove a warning for menucofig
Thread-Topic: [PATCH 1/1] script/kconfig: remove a warning for menucofig
Thread-Index: AQHPlBHdItIp9bBBQ0OFqHOm4gNIfZuJ4g6AgABmSBA=
Date: Mon, 30 Jun 2014 23:10:32 +0000
Message-ID: <1267BB84A242B24E81E0C0C8955CFFC061A30C1D@G9W0343.americas.hpqcorp.net>
References: <1404098187-9638-1-git-send-email-zhen-hual@hp.com>
 <53B1982F.4030504@gmx.de>
In-Reply-To: <53B1982F.4030504@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5UNBiCp017944

When malloc for jump, 
if (head && location) {
	jump = xmalloc(sizeof(struct jump_key));
	....
}
And here it is used:
if (head && location && menu == location)
	jump->offset = strlen(r->s);


So I think when jump is used, it must not be NULL; then !=NULL is not needed.
-----Original Message-----
From: Heinrich Schuchardt [mailto:xypron.glpk@gmx.de] 
Sent: Tuesday, July 01, 2014 1:03 AM
To: Li, Zhen-Hua; Yann E. MORIN; linux-kbuild@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] script/kconfig: remove a warning for menucofig

On 30.06.2014 05:16, Li, Zhen-Hua wrote:
> There is a warning when run "make menuconfig".
>
> scripts/kconfig/menu.c: In function â€˜get_symbol_strâ€™:
> scripts/kconfig/menu.c:591:18: warning: â€˜jumpâ€™ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
>       jump->offset = strlen(r->s);
>                    ^
> scripts/kconfig/menu.c:551:19: note: â€˜jumpâ€™ was declared here
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
