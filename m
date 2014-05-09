Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaEIOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:47:38 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:60044 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIOrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <536CE414.5030406@suse.de>
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com>
 <536A57FA.2090608@wwwdotorg.org> <536AC45F.6080608@nvidia.com> <536CE414.5030406@suse.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 9 May 2014 23:47:15 +0900
Message-ID: <CAAVeFuJkdfYZdSvh4OuwqxiuyyoYtBnHH16L4gJrbAvo2F-w0w@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 11:20 PM, Andreas Färber <afaerber@suse.de> wrote:
> Am 08.05.2014 01:40, schrieb Alex Courbot:
>> On 05/08/2014 12:57 AM, Stephen Warren wrote:
>>> On 05/06/2014 09:18 PM, Alexandre Courbot wrote:
>>>> Console rotation is needed for devices like Tegra Note 7 and NVIDIA
>>>> SHIELD to get the boot console in the expected orientation.
>>>
>>> I've squashed this into Tegra's for-3.16/defconfig branch.
>>>
>>> Can you please also update multi_v7_defconfig, and send that change to
>>> arm-soc (arm@kernel.org) to be applied. Thanks.
>>
>> I omitted doing this for now because the devices that require this
>> option (TN7/SHIELD) need a custom build with appended DTB and/or
>> command-line anyway. Therefore they cannot use a multi-mach kernel
>
> What does appending a .dtb have to do with whether or not to use a
> multi-mach kernel? We package zImage/uImage and .dtbs separately, so
> surely the multi_v7_defconfig should be kept working with Tegra devices.
> Appending a .dtb only comes into play for preparing installation images.

When appending a dtb the kernel image must also be built with
CONFIG_ARM_APPENDED_DTB, which I guess is not an option we want to add
by default to Tegra and probably even less to multi_v7. So since the
kernel config needs to be changed anyway, I thought we would always
want to use tegra_defconfig as a basis for these devices.

Not that adding CONFIG_FRAMEBUFFER_CONSOLE_ROTATION to multi_v7 would
inflate the resulting kernel much, though.
