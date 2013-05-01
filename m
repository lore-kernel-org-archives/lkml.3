Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3EATde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:33:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab3EATd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:33:26 -0400
Message-ID: <51816DE6.9060308@infradead.org>
Date: Wed, 01 May 2013 12:32:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <518157EB.3010700@infradead.org> <20130501192845.GA18811@free.fr>
In-Reply-To: <20130501192845.GA18811@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/13 12:28, Yann E. MORIN wrote:
> On Wed, May 01, 2013 at 10:59:07AM -0700, Randy Dunlap wrote:
>> On 05/01/13 01:37, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Please do not add any v3.11 destined work to your linux-next included
>>> branches until after v3.10-rc1 is released.
>>>
>>> Changes since 20130430:
>>>
>>
>>
>> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
>> CONFIG_VIDEO_STK1160=y
>> CONFIG_VIDEO_STK1160_AC97=y
>>
>> drivers/built-in.o: In function `stk1160_ac97_register':
>> (.text+0x122706): undefined reference to `snd_card_create'
>> drivers/built-in.o: In function `stk1160_ac97_register':
>> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
>> drivers/built-in.o: In function `stk1160_ac97_register':
>> (.text+0x1227cd): undefined reference to `snd_card_free'
>> drivers/built-in.o: In function `stk1160_ac97_register':
>> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
>> drivers/built-in.o: In function `stk1160_ac97_register':
>> (.text+0x122832): undefined reference to `snd_card_register'
>> drivers/built-in.o: In function `stk1160_ac97_unregister':
>> (.text+0x12285e): undefined reference to `snd_card_free'
>>
>>
>> This kconfig fragment:
>> config VIDEO_STK1160_AC97
>> 	bool "STK1160 AC97 codec support"
>> 	depends on VIDEO_STK1160 && SND
>> 	select SND_AC97_CODEC
>>
>> is unreliable (doesn't do what some people expect) when SND=m and SND_AC97_CODEC=m,
>> since VIDEO_STK1160_AC97 is a bool.
> 
> I'm not sure to understand what you want, here.

I just want the build errors fixed.  I'm not asking for any particular fix.

> I find it valid that a 'bool' can 'select' a 'tristate', to force it to 'y'.

But a bool selecting a tristate that already =m does not force it to y AFAICT.
I guess that would be an acceptable change/fix.  Maybe.

> Do you mean there is an issue with Kconfig, the parser?

I think so.

>   -> should Kconfig warn or error out in such a case?
> 
> Or do you mean the structure above is wrong, and should be ammended?
>   -> change the 'select' to a 'depends on'?

That should be one way to fix the problem, yes.

>   -> change the symbol to a tristate?

I thought about that, but I don't think that it will work.  There is no
separate module that is built for AC97 codec support.


thanks,
-- 
~Randy
