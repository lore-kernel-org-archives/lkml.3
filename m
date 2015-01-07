Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbbAGRPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:15:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60812 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbAGRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:15:11 -0500
Message-ID: <54AD69CC.7010902@wwwdotorg.org>
Date: Wed, 07 Jan 2015 10:15:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: tegra: rely on bootloader pinmux programming
 on nyan-big
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com> <1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com> <54AC16B0.5050703@wwwdotorg.org> <CAAObsKB1gMcLZ=n8Mc6JSLQHn5-6VWOhERLgYTdi6nit6yCj5w@mail.gmail.com>
In-Reply-To: <CAAObsKB1gMcLZ=n8Mc6JSLQHn5-6VWOhERLgYTdi6nit6yCj5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 01:06 AM, Tomeu Vizoso wrote:
> On 6 January 2015 at 18:09, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/06/2015 03:37 AM, Tomeu Vizoso wrote:
>>>
>>> Following 6dbaff2b, the kernel expects that the bootloader has correctly
>>> programmed the Tegra pinmux.
>>>
>>> DTs for the Jetson and the Venice2 had been updated already but this one
>>> was left behind.
>>
>>
>> So this setup is true for NVIDIA-controlled development/reference boards
>> where we've ensured that the bootloader sets up 100% of the pinmux.
>>
>> However, I know that Coreboot on this board doesn't set up everything in the
>> pinmux, and since it's in r/o flash never will. As such, I'm not sure this
>> change is safe for this board. That is, unless you want to force upstream
>> kernels to be booted via a chain-loaded path: Coreboot (r/o) -> U-Boot (r/w
>> with full pinmux setup) -> kernel.
>>
>>> Have tested this with the stock vendor firmware (coreboot) and have found
>>> no
>>> issues.
>>
>>
>> There are presumably a bunch of features which aren't yet supported
>> upstream, and hence you couldn't test though? That means we might find that
>> parts of the pinmux aren't yet programmed but need to be to enable those
>> features.
>
> Sure, there's no chance that my testing could have been extensive enough.
>
> Following Andrew's feedback, I will be looking at getting the pinmux
> programming right in the DTs.

As an FYI, the way this typically works (for NVIDIA reference boards, 
and many/most customer boards) is that NVIDIA syseng publishes an Excel 
spreadsheet that can be edited to define the board's pinmux, and which 
performs some error checks. This spreadsheet can directly generate (via 
Excel macros/...) pinmux data tables and/or DT files for our 
product/internal/downstream Android and L4T kernels. For recent SoCs, 
the tegra-pinmux-scripts project[1] can take a CSV representation of the 
spreadsheet and generate both a U-Boot header file (for upstream or L4T; 
they're the same) and upstream Linux kernel DT files that represent the 
pinmux.

So, your best bet is to see if such a spreadsheet exists for these 
platforms, and import it into tegra-pinmux-scripts. That will save a lot 
of work if the spreadsheet exists (and is up-to-date).

[1] https://github.com/NVIDIA/tegra-pinmux-scripts
