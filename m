Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaGNQaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:30:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:58013 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbaGNQaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:30:10 -0400
Message-ID: <53C40589.8050202@gmx.de>
Date: Mon, 14 Jul 2014 18:30:01 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] script/kconfig: remove a warning for menucofig
References: <1404098187-9638-1-git-send-email-zhen-hual@hp.com> <53B1982F.4030504@gmx.de> <1267BB84A242B24E81E0C0C8955CFFC061A30C1D@G9W0343.americas.hpqcorp.net>
In-Reply-To: <1267BB84A242B24E81E0C0C8955CFFC061A30C1D@G9W0343.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:iNxKIGab6so2sW0encIlQyzU0AdXCIEsH8ZdzCXpQbFcGt5LtHZ
 oqkHyC7bZMRTFnSdIfojCJefFQ+l/1fFOtcKti4LbxIoQCHAWDc003+OBonPaF3s/Lph5n9
 18/5txiALxcS001SxEB57V+wNUeX0FymHo7D00Af0gM0mV8sE/eqY0IylS316qjjXPpaq5j
 A8UOJz1+ZtQ6RAYBwazfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.07.2014 01:10, Li, Zhen-Hua wrote:
> When malloc for jump,
> if (head && location) {
> 	jump = xmalloc(sizeof(struct jump_key));
> 	....
> }
> And here it is used:
> if (head && location && menu == location)
> 	jump->offset = strlen(r->s);
>
>
> So I think when jump is used, it must not be NULL; then !=NULL is not needed.

I tested the patch against v13.6-rc5. It fixes the problem with the warning.

You can add

Reviewed-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Best regards

Heinrich


> -----Original Message-----
> From: Heinrich Schuchardt [mailto:xypron.glpk@gmx.de]
> Sent: Tuesday, July 01, 2014 1:03 AM
> To: Li, Zhen-Hua; Yann E. MORIN; linux-kbuild@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] script/kconfig: remove a warning for menucofig
>
> On 30.06.2014 05:16, Li, Zhen-Hua wrote:
>> There is a warning when run "make menuconfig".
>>
>> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
>> scripts/kconfig/menu.c:591:18: warning: ‘jump’ may be used uninitialized in
>> this function [-Wmaybe-uninitialized]
>>        jump->offset = strlen(r->s);
>>                     ^
>> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>>     struct jump_key *jump;
>>                      ^
>>
>> It is because the compiler think "jump" is not initialized, though in fact
>> it is already initialized.
>>
>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>> ---
>>    scripts/kconfig/menu.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
>> index a26cc5d..584e0fc 100644
>> --- a/scripts/kconfig/menu.c
>> +++ b/scripts/kconfig/menu.c
>> @@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>>    {
>>    	int i, j;
>>    	struct menu *submenu[8], *menu, *location = NULL;
>> -	struct jump_key *jump;
>> +	struct jump_key *jump = NULL;
>>
>>    	str_printf(r, _("Prompt: %s\n"), _(prop->text));
>>    	menu = prop->menu->parent;
>>
> Hello Zhen-Hua,
>
> the patch looks incomplete to me. A check
> jump != NULL
> should be added before accessing parts of structure jump_key.
>
> Best regards
>
> Heinrich Schuchardt
>

