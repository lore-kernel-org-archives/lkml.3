Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbbAGIGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:06:53 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36761 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbAGIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:06:51 -0500
MIME-Version: 1.0
In-Reply-To: <54AC16B0.5050703@wwwdotorg.org>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
 <1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com> <54AC16B0.5050703@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 7 Jan 2015 09:06:30 +0100
X-Google-Sender-Auth: ZEY8huP9A47l-8mRl1gpQhtsmAU
Message-ID: <CAAObsKB1gMcLZ=n8Mc6JSLQHn5-6VWOhERLgYTdi6nit6yCj5w@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: tegra: rely on bootloader pinmux programming on nyan-big
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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

On 6 January 2015 at 18:09, Stephen Warren <swarren@wwwdotorg.org> wrote:
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
>
>> Have tested this with the stock vendor firmware (coreboot) and have found
>> no
>> issues.
>
>
> There are presumably a bunch of features which aren't yet supported
> upstream, and hence you couldn't test though? That means we might find that
> parts of the pinmux aren't yet programmed but need to be to enable those
> features.

Sure, there's no chance that my testing could have been extensive enough.

Following Andrew's feedback, I will be looking at getting the pinmux
programming right in the DTs.

Thanks,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
