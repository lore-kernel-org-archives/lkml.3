Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3FEX0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:26:37 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33335 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3FEX0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:26:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	<51AFA6DD.3000202@wwwdotorg.org>
	<CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	<1370469574.18839.33.camel@localhost>
	<CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	<CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
Date: Thu, 6 Jun 2013 00:26:35 +0100
Message-ID: <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 12:07 AM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
> On Wed, Jun 5, 2013 at 6:47 PM, luke.leighton <luke.leighton@gmail.com> wrote:
>> On Wed, Jun 5, 2013 at 10:59 PM, Henrik Nordström
>> <henrik@henriknordstrom.net> wrote:
>>
>>>>  .... and then there's the boot0 and boot1 loaders, these *do* have
>>
>>> no, these are not tiny. boot0 is 24KB to fit the initial embedded SRAM
>>> (not cache), but boot1 is on pair with u-boot in size and runs from
>>> DRAM.
>>
>>  btw, please listen to henrik: he knows what he's talking about, as
>> you can see :)   henrik, thank you for correcting my technical
>> misunderstandings, i'll try to remember them and not propagate
>> incorrect stuff.
>
> This is not about the fex syntax or uboot. The root problem is needing
> two sets of binding for every device driver in the kernel. Pick a
> random driver like gpio-pca953x.c and look at the source. In that file
> there are #ifdef CONFIG_OF_ sections. Those sections are directly
> reading the FDT binary via calls like of_get_property(node,
> "linux,gpio-base", &size);. If fex is added to the kernel every driver
> driver will now need both a #ifdef CONFIG_OF_ section and also a
> #ifdef CONFIG_FEX_ section. Doing that is just crazy.

 yes.  which is why they haven't done it.

> Is Allwinner
> going to add fex support to every single device driver in the kernel?

 no john - they've only added it to the multiplexed sections of the
drivers which they themselves have written.  such as
drivers/usb/sun{N}i_usb/*.[ch], drivers/block/nand/sun{N}_i,
arch/arm/mach-sun{N}i and so on.

even the touchscreen driver that they wrote, that's got nothing to do
with any other code in the touchscreen linux kernel source tree: it's
more of a "meta-"driver which even has the name of the linux kernel
module that needs to be loaded and what I2C address, GPIO options etc.
to pass in [normally done as modprobe options in userspace].

 to be honest, there are better people to fully answer this question
(alejandro and henrik are two that spring to mind) but you're
definitely off-base, jon.  the script.fex system deals with the pinmux
issue in a very neat way that:

  a) has very little impact on the rest of the kernel tree [citation
needed!  i'm saying that: could someone please confirm if it's true]

  b) the linux kernel developers could, instead of criticising it,
actually learn a great deal from.

l.
