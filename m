Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab3FSBJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:09:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54655 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3FSBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <51C07608.2070406@infradead.org>
References: <alpine.DEB.2.02.1306181705530.28460@M2420>
	<1371560680.3495.121.camel@deadeye.wl.decadent.org.uk>
	<51C07608.2070406@infradead.org>
Date: Wed, 19 Jun 2013 09:09:11 +0800
Message-ID: <CADJHv_vZiPsDUiLrFao41rRVduf+AYFm0NuvpNaCW8S3KrAjnA@mail.gmail.com>
Subject: Re: [PATCH]amilo-rfkill: add depends on i8042 in Kconfig
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, matthew.garrett@nebula.com,
        platform-driver-x86@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, jim.epost@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/18 Randy Dunlap <rdunlap@infradead.org>:
> On 06/18/13 06:04, Ben Hutchings wrote:
>> On Tue, 2013-06-18 at 17:21 +0800, Xiong Zhou wrote:
>>> From: Xiong Zhou <jencce.kernel@gmail.com>
>>>
>>> Fix randconfig build failure for Amilo x86 platform driver.
>>> AMILO_RFKILL requires SERIO_I8042 being available.
>>>
>>> amilo-rfkill.c:(.text+0x108b5b): undefined reference to `i8042_lock_chip'
>>> amilo-rfkill.c:(.text+0x108b69): undefined reference to `i8042_command'
>>> amilo-rfkill.c:(.text+0x108b71): undefined reference to `i8042_unlock_chip'
>>>
>>> Reported-by: Jim Davis <jim.epost@gmail.com>
>>> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>>
>> Acked-by: Ben Hutchings <ben@decadent.org.uk>
>>
>> But I thought somehow sent this same fix a while back...
>
> Yes, I reported it and sent a patch for it that you acked...
> I guess my patch was never picked up.
>

... Better someone pick this up.


>>
>> Ben.
>>
>>> ---
>>>  drivers/platform/x86/Kconfig |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>>> index 8577261..37645b9 100644
>>> --- a/drivers/platform/x86/Kconfig
>>> +++ b/drivers/platform/x86/Kconfig
>>> @@ -176,6 +176,7 @@ config FUJITSU_TABLET
>>>  config AMILO_RFKILL
>>>      tristate "Fujitsu-Siemens Amilo rfkill support"
>>>      depends on RFKILL
>>> +    depends on SERIO_I8042
>>>      ---help---
>>>        This is a driver for enabling wifi on some Fujitsu-Siemens Amilo
>>>        laptops.
>>
>
>
> --
> ~Randy
