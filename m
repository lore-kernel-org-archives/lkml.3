Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3HCPxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 11:53:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59755 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3HCPxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 11:53:33 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CANq1E4SjN-=3oyRp2zXaQ+aaJB8yEVmJzcPvbxQxu1MTc8JjiQ@mail.gmail.com>
References: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com> <51FC431F.1080405@zytor.com> <CANq1E4SjN-=3oyRp2zXaQ+aaJB8yEVmJzcPvbxQxu1MTc8JjiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND 0/8] x86 platform framebuffers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 03 Aug 2013 08:53:00 -0700
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <cf7f27cd-4b3e-41bf-ba26-0955a93b04ec@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiled for i386 PAE phys_addr_t is 64 bits but pointers are 32 bits.

David Herrmann <dh.herrmann@gmail.com> wrote:
>Hi
>
>On Sat, Aug 3, 2013 at 1:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/02/2013 05:05 AM, David Herrmann wrote:
>>> Hi
>>>
>>> I cut down my previous series to no longer include the SimpleDRM
>driver. If
>>> anyone is interested, you can find it here:
>>>   http://lwn.net/Articles/558104/
>>> I will resend it once these preparation patches are in.
>>>
>>> Changes since v2:
>>>  - added common x86 formats (reported by hpa) (patch #5)
>>>
>>> This whole series (including simpledrm) is tested by Stephen and me.
>I would be
>>> glad if maintainers could ack/nack this so I can continue my work.
>>>
>>> This series is pretty small and just converts x86 to use
>platform-devices
>>> instead of global objects to pass framebuffer data to drivers. The
>commit
>>> messages explain everything in detail.
>>> The idea is to create a "platform-framebuffer" device which drivers
>can bind to.
>>> If x86 boot code detectes efi or vesa framebuffers, it creates
>efi-framebuffer
>>> or vesa-framebuffer devices instead.
>>>
>>> Additionally, if the modes are compatible, "simple-framebuffer"
>devices are
>>> created so simplefb can be used on x86. This feature is only enabled
>if
>>> CONFIG_X86_SYSFB is selected (off by default) so users without
>simplefb still
>>> get boot logs.
>>>
>>>  @Stephen: I wasn't sure whether you tested the efi/vesa framebuffer
>changes,
>>> too, so I didn't add your tested-by there. And I changed patch #5 so
>I dropped
>>> it there, too. Thanks for testing!
>>>
>>
>> I am getting a bunch of new warnings with this patchset, typically of
>> the form:
>>
>>
>> /home/hpa/kernel/distwork/drivers/video/arkfb.c:1019:23: warning:
>cast
>> to pointer from integer of different size [-Wint-to-pointer-cast]
>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>                        ^
>> /home/hpa/kernel/distwork/drivers/video/s3fb.c: In function
>‘s3_pci_probe’:
>> /home/hpa/kernel/distwork/drivers/video/s3fb.c:1186:23: warning: cast
>to
>> pointer from integer of different size [-Wint-to-pointer-cast]
>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>                        ^
>> I have pushed it out to a topic branch in the tip tree, partly to
>give
>> Fengguang's build bot a run at it (it is excellent at spotting the
>> origin of new warnings), but this needs to be fixed; we will not
>merge
>> this branch in its current form.
>
>Thanks for looking at it. However, these warnings seem unrelated to my
>patchset. I didn't change any vga/fb headers nor did I touch
>arkfb/s3fb. Furthermore, I cannot reproduce these warnings. "vga_res"
>is a "struct resource", "->start" is of type "resource_size_t" which
>is typedef'ed to "phys_addr_t". Seems like the build-bot used some
>random config with CONFIG_PHYS_ADDR_T_64BIT set but building on 32bit
>(or something like that).
>
>Is there any place where I can see the compiler log? Or the used
>.config file?
>
>Thanks
>David

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
