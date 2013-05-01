Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3EAU66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:58:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:58702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3EAU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:58:56 -0400
Message-ID: <518181F2.3@infradead.org>
Date: Wed, 01 May 2013 13:58:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <518157EB.3010700@infradead.org> <20130501192845.GA18811@free.fr> <alpine.DEB.2.02.1305011258180.8448@chino.kir.corp.google.com> <518179BD.3010407@infradead.org> <20130501205355.GB18811@free.fr>
In-Reply-To: <20130501205355.GB18811@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/13 13:53, Yann E. MORIN wrote:
> Randy, All,
> 
> On Wed, May 01, 2013 at 01:23:25PM -0700, Randy Dunlap wrote:
>> On 05/01/13 12:58, David Rientjes wrote:
>>> On Wed, 1 May 2013, Yann E. MORIN wrote:
>>>
>>>>> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
>>>>> CONFIG_VIDEO_STK1160=y
>>>>> CONFIG_VIDEO_STK1160_AC97=y
>>>>>
>>>>> drivers/built-in.o: In function `stk1160_ac97_register':
>>>>> (.text+0x122706): undefined reference to `snd_card_create'
>>>>> drivers/built-in.o: In function `stk1160_ac97_register':
>>>>> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
>>>>> drivers/built-in.o: In function `stk1160_ac97_register':
>>>>> (.text+0x1227cd): undefined reference to `snd_card_free'
>>>>> drivers/built-in.o: In function `stk1160_ac97_register':
>>>>> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
>>>>> drivers/built-in.o: In function `stk1160_ac97_register':
>>>>> (.text+0x122832): undefined reference to `snd_card_register'
>>>>> drivers/built-in.o: In function `stk1160_ac97_unregister':
>>>>> (.text+0x12285e): undefined reference to `snd_card_free'
>>>>>
>>>>>
>>>>> This kconfig fragment:
>>>>> config VIDEO_STK1160_AC97
>>>>> 	bool "STK1160 AC97 codec support"
>>>>> 	depends on VIDEO_STK1160 && SND
> 
> BTW, can you check that:
>     make silentoldconfig
> does not warn about unmet dependencies for those symbols?

'make silentoldconfig' on the config file that I am using only gives me this:

warning: (VIDEO_EM28XX) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT)


>>> This doesn't depend on SND, it depends on SND=y.
>>
>> Maybe this option *should* depend on SND=y, but that's not what the
>> kconfig syntax says.
> 
> I'd say  Documentation/kbuild/kconfig-language.txt  is not complete wrt
> the current syntax, grammar and semantics of the language. :-(

OK, that's not surprising.

thanks,
-- 
~Randy
