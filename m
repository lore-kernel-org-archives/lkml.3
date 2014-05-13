Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaEMUQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:16:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaEMUQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:16:35 -0400
Message-ID: <53727D9E.9050800@suse.de>
Date: Tue, 13 May 2014 22:16:30 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Alex Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com> <536A57FA.2090608@wwwdotorg.org> <536AC45F.6080608@nvidia.com> <536CE414.5030406@suse.de> <536CF33A.3020906@wwwdotorg.org>
In-Reply-To: <536CF33A.3020906@wwwdotorg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.05.2014 17:24, schrieb Stephen Warren:
> On 05/09/2014 08:20 AM, Andreas Färber wrote:
>> Am 08.05.2014 01:40, schrieb Alex Courbot:
>>> On 05/08/2014 12:57 AM, Stephen Warren wrote:
>>>> On 05/06/2014 09:18 PM, Alexandre Courbot wrote:
>>>>> Console rotation is needed for devices like Tegra Note 7 and NVIDIA
>>>>> SHIELD to get the boot console in the expected orientation.
>>>>
>>>> I've squashed this into Tegra's for-3.16/defconfig branch.
>>>>
>>>> Can you please also update multi_v7_defconfig, and send that change to
>>>> arm-soc (arm@kernel.org) to be applied. Thanks.
>>>
>>> I omitted doing this for now because the devices that require this
>>> option (TN7/SHIELD) need a custom build with appended DTB and/or
>>> command-line anyway. Therefore they cannot use a multi-mach kernel
>>
>> What does appending a .dtb have to do with whether or not to use a
>> multi-mach kernel? We package zImage/uImage and .dtbs separately, so
>> surely the multi_v7_defconfig should be kept working with Tegra devices.
>> Appending a .dtb only comes into play for preparing installation images.
> 
> That would be a reasonable argument if generic distro installers or
> kernel packages were likely to support the TN7 and SHIELD. However,
> given the bootloader situation there and the need for a custom kernel
> anyway for APPENDED_DTB, I assume that's not the case on this particular
> device?

The Shield we probably don't, the TN7 I don't know. I was more concerned
about the shortened justification.

> If you do intend to support this device with SuSe installer and kernel
> packages, could you give an outline of how you do so?

I gave a presentation at embedded world Conference 2014 on how standard
distributions work on ARM/AArch64, but I fear the slides are not online.

As far as possible, we use a single kernel source and a "default" or
"lpae" v7 multi-platform config with lots of modules enabled.

http://kernel.opensuse.org/cgit/kernel-source/tree/config/armv7hl [*]

I just double-checked, and we do have CONFIG_ARM_APPENDED_DTB=y enabled.
It does not restrict supplying the .dtb the "normal" way AIUI.

Our Open Build Service instance then builds a kernel-default .rpm
package containing zImage and modules. The .dts files are separately
compiled and packaged as, e.g., dtb-tegra2 for /boot/dtb/tegra20-*.dtb.

For building initrd, U-Boot boot.scr (including kernel command line) and
installation image, we use Kiwi.

Anyway, we don't rely on the defconfigs for our distro, so do as you see
fit; just gently reminding that it's not feasible for everyone to build
kernels per device, as the above comment seemed to suggest.

Best regards,

Andreas


[*] Yes, some Tegra options are clearly missing; working on syncing them
based on my tegra_defconfig.

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
