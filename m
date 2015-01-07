Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbbAGDhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:37:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65309 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbAGDhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <54AC16B0.5050703@wwwdotorg.org>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
	<1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com>
	<54AC16B0.5050703@wwwdotorg.org>
Date: Tue, 6 Jan 2015 19:37:04 -0800
X-Google-Sender-Auth: GTMgkf1mCEVk2XNJrA9rfmRnGLw
Message-ID: <CAL1qeaG4S89Ndgd6QpD+PMj7p5iWhamyoznN1avs9uPjUmzT4A@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: tegra: rely on bootloader pinmux programming on nyan-big
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:09 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/06/2015 03:37 AM, Tomeu Vizoso wrote:
>>
>> Following 6dbaff2b, the kernel expects that the bootloader has correctly
>> programmed the Tegra pinmux.
>>
>> DTs for the Jetson and the Venice2 had been updated already but this one
>> was left behind.
>
>
> So this setup is true for NVIDIA-controlled development/reference boards
> where we've ensured that the bootloader sets up 100% of the pinmux.
>
> However, I know that Coreboot on this board doesn't set up everything in the
> pinmux, and since it's in r/o flash never will. As such, I'm not sure this
> change is safe for this board. That is, unless you want to force upstream
> kernels to be booted via a chain-loaded path: Coreboot (r/o) -> U-Boot (r/w
> with full pinmux setup) -> kernel.

That's correct.  We did have a patch floating around to configure all
the pinmux settings in coreboot, but that never made it in.  While we
could issue a R/W firmware update to apply the pinmux settings
(unlikely to happen), it would still result in pinmux settings being
applied in two separate locations - which, IIRC, was exactly what
Stephen was trying to avoid by moving pinmux out of the device-trees.
So I'd agree that pulling the pinmux settings out of the nyan*
device-trees is not a good idea.
