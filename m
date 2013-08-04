Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3HDRa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:30:28 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61542 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3HDRa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <cf7f27cd-4b3e-41bf-ba26-0955a93b04ec@email.android.com>
References: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
	<51FC431F.1080405@zytor.com>
	<CANq1E4SjN-=3oyRp2zXaQ+aaJB8yEVmJzcPvbxQxu1MTc8JjiQ@mail.gmail.com>
	<cf7f27cd-4b3e-41bf-ba26-0955a93b04ec@email.android.com>
Date: Sun, 4 Aug 2013 19:30:25 +0200
Message-ID: <CANq1E4S+MSv2s+ikPuJ7+jzbQfQFxjdj7wBk54e=n57GtZ0eeA@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/8] x86 platform framebuffers
From: David Herrmann <dh.herrmann@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Aug 3, 2013 at 5:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> When compiled for i386 PAE phys_addr_t is 64 bits but pointers are 32 bits.

Yepp, that makes sense. I am not really comfortable fixing this as I
have no idea how PAE actually works, but I digged through git history
and sent a patch to linux-fbdev (I put you on CC). The (long)-cast
should be sufficient, I guess.

Were there any other build warnings you encountered?

Thanks
David

> David Herrmann <dh.herrmann@gmail.com> wrote:
>>Hi
>>
>>On Sat, Aug 3, 2013 at 1:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 08/02/2013 05:05 AM, David Herrmann wrote:
>>>> Hi
>>>>
>>>> I cut down my previous series to no longer include the SimpleDRM
>>driver. If
>>>> anyone is interested, you can find it here:
>>>>   http://lwn.net/Articles/558104/
>>>> I will resend it once these preparation patches are in.
>>>>
>>>> Changes since v2:
>>>>  - added common x86 formats (reported by hpa) (patch #5)
>>>>
>>>> This whole series (including simpledrm) is tested by Stephen and me.
>>I would be
>>>> glad if maintainers could ack/nack this so I can continue my work.
>>>>
>>>> This series is pretty small and just converts x86 to use
>>platform-devices
>>>> instead of global objects to pass framebuffer data to drivers. The
>>commit
>>>> messages explain everything in detail.
>>>> The idea is to create a "platform-framebuffer" device which drivers
>>can bind to.
>>>> If x86 boot code detectes efi or vesa framebuffers, it creates
>>efi-framebuffer
>>>> or vesa-framebuffer devices instead.
>>>>
>>>> Additionally, if the modes are compatible, "simple-framebuffer"
>>devices are
>>>> created so simplefb can be used on x86. This feature is only enabled
>>if
>>>> CONFIG_X86_SYSFB is selected (off by default) so users without
>>simplefb still
>>>> get boot logs.
>>>>
>>>>  @Stephen: I wasn't sure whether you tested the efi/vesa framebuffer
>>changes,
>>>> too, so I didn't add your tested-by there. And I changed patch #5 so
>>I dropped
>>>> it there, too. Thanks for testing!
>>>>
>>>
>>> I am getting a bunch of new warnings with this patchset, typically of
>>> the form:
>>>
>>>
>>> /home/hpa/kernel/distwork/drivers/video/arkfb.c:1019:23: warning:
>>cast
>>> to pointer from integer of different size [-Wint-to-pointer-cast]
>>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>>                        ^
>>> /home/hpa/kernel/distwork/drivers/video/s3fb.c: In function
>>‘s3_pci_probe’:
>>> /home/hpa/kernel/distwork/drivers/video/s3fb.c:1186:23: warning: cast
>>to
>>> pointer from integer of different size [-Wint-to-pointer-cast]
>>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>>                        ^
>>> I have pushed it out to a topic branch in the tip tree, partly to
>>give
>>> Fengguang's build bot a run at it (it is excellent at spotting the
>>> origin of new warnings), but this needs to be fixed; we will not
>>merge
>>> this branch in its current form.
>>
>>Thanks for looking at it. However, these warnings seem unrelated to my
>>patchset. I didn't change any vga/fb headers nor did I touch
>>arkfb/s3fb. Furthermore, I cannot reproduce these warnings. "vga_res"
>>is a "struct resource", "->start" is of type "resource_size_t" which
>>is typedef'ed to "phys_addr_t". Seems like the build-bot used some
>>random config with CONFIG_PHYS_ADDR_T_64BIT set but building on 32bit
>>(or something like that).
>>
>>Is there any place where I can see the compiler log? Or the used
>>.config file?
>>
>>Thanks
>>David
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
