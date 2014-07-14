Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaGNG0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:26:49 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:56131 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaGNG0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:26:41 -0400
Message-ID: <53C377CC.8030909@hp.com>
Date: Mon, 14 Jul 2014 14:25:16 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] script/kconfig: remove a warning for menucofig
References: <1404098187-9638-1-git-send-email-zhen-hual@hp.com> <53B1982F.4030504@gmx.de>
In-Reply-To: <53B1982F.4030504@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update?

On 07/01/2014 01:02 AM, Heinrich Schuchardt wrote:
> On 30.06.2014 05:16, Li, Zhen-Hua wrote:
>> There is a warning when run "make menuconfig".
>>
>> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
>> scripts/kconfig/menu.c:591:18: warning: ‘jump’ may be used 
>> uninitialized in
>> this function [-Wmaybe-uninitialized]
>>       jump->offset = strlen(r->s);
>>                    ^
>> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>>    struct jump_key *jump;
>>                     ^
>>
>> It is because the compiler think "jump" is not initialized, though in 
>> fact
>> it is already initialized.
>>
>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>> ---
>>   scripts/kconfig/menu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
>> index a26cc5d..584e0fc 100644
>> --- a/scripts/kconfig/menu.c
>> +++ b/scripts/kconfig/menu.c
>> @@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct 
>> property *prop,
>>   {
>>       int i, j;
>>       struct menu *submenu[8], *menu, *location = NULL;
>> -    struct jump_key *jump;
>> +    struct jump_key *jump = NULL;
>>
>>       str_printf(r, _("Prompt: %s\n"), _(prop->text));
>>       menu = prop->menu->parent;
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

