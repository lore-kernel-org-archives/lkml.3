Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaJ1QF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:05:26 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:33172 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaJ1QFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:05:23 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 12:05:23 EDT
X-Spam-Flag: NO
X-Spam-Score: 0.202
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 3D5F24C314F
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de C4C8CE615D
Message-ID: <544FBCC8.6000800@vodafone.de>
Date: Tue, 28 Oct 2014 16:56:56 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Shell <list1@michaelshell.org>
CC: Alex Deucher <alexander.deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        =?UTF-8?B?Q2hyaXN0aWE=?= =?UTF-8?B?biBLw7ZuaWc=?= 
	<christian.koenig@amd.com>
Subject: Re: Standard VGA console with DRI/DRM under X?
References: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org> <CAErSpo4zDxhG08FjyV9BJ+=cJLGYkyocz87ZRWndw70ND3g6XA@mail.gmail.com>
In-Reply-To: <CAErSpo4zDxhG08FjyV9BJ+=cJLGYkyocz87ZRWndw70ND3g6XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this possible and if not, why not?
Long story short on modern hardware the VGA console is just an emulation 
working on top of the real hardware. When the driver wants to talk to 
the real hardware it must simply disable the VGA emulation first.

But to me all points why you don't like the fbcon are just a matter of 
configuring it correctly, so you might want to look into that direction 
as well.

Regards,
Christian.

Am 28.10.2014 um 16:48 schrieb Bjorn Helgaas:
> [+cc David, Alex, Christian, dri-devel]
>
> On Tue, Oct 28, 2014 at 12:32 AM, Michael Shell <list1@michaelshell.org> wrote:
>>
>>    Greetings,
>>
>> Well, I want to be able to have my cake and eat it too. I want to be able to
>> have the standard VGA/"hardware" classic console (not the framebuffer) but
>> I still want the /dev/dri/cardX devices so that I can use DRI under Xorg.
>>
>> Is this possible and if not, why not?
>>
>>
>> (I do hope I'm not bring up an issue with an obvious fix, but my searching
>>   has not yielded an answer yet. For the record, I'm running modern kernel
>>   (3.16.3) with much older x86 hardware [r100 Radeon video card].)
>>
>>
>> If I boot with the kernel nomodeset option I can get the classic
>> VGA/"hardware" console, but then I lose support for DRI/DRM:
>>
>> Oct 27 15:11:09 X kernel: [drm] Initialized drm 1.1.0 20060810
>> Oct 27 15:11:09 X kernel: [drm] VGACON disable radeon kernel modesetting.
>> Oct 27 15:11:09 X kernel: [drm:radeon_init] *ERROR* No UMS support in radeon module
>>
>> and glxgears et al. turns slow. In more modern Xorg releases, DRI is
>> required for all hardware acceleration, so having /dev/dri/cardX is very
>> important:
>>
>> http://askubuntu.com/questions/463142/why-x-is-relying-on-software-instead-of-hardware-with-nomodeset-kernel-paramet
>>
>>
>> One reason I do not wish to use the framebuffer console is because of the
>> small font. 160 columns makes it difficult to tell which [OK] belongs with
>> which service. The selection of console fonts should always include a
>> set that gives us an 80 column screen and the docs should point this out.
>>
>> And I dislike any blanking or video mode changes during boot.
>>
>> Can't the kernel just declare that it is capable of setting the video mode,
>> provide the /dev/dri/cardX devices and leave the console alone, but still
>> allow Xorg to call for a new mode and use /dev/dri/cardX if/when it sees fit?
>>
>> In an ideal world, there would be some kernel option such as fbcon=no.
>>
>> In the kernel Documentation fbcon.txt it mentions "fbcon=map:1 tells fbcon not
>> to take over the console." But, IIRC, from my tests I wasn't able to use this
>> to get a VGA/"hardware" console and still be able to have /dev/dri/cardX devices.
>>
>>
>>
>>      Cheers and thank you,
>>
>>      Mike Shell
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

