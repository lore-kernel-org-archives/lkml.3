Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3FNOdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:33:31 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59957 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3FNOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130612224235.GA8146@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
	<1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
	<20130612224235.GA8146@quad.lixom.net>
Date: Fri, 14 Jun 2013 16:33:29 +0200
Message-ID: <CACmBeS1xNgc=TN3ZdhhHS0K+SMU+Zc1cvH7VXQHiTye=Ufoj8Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: mach-moxart: add MOXA ART SoC files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        arm@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the replies.

What isn't commented below should already be fixed. I'll resubmit the
entire set when it looks like there's nothing left to amend.

On 13 June 2013 00:42, Olof Johansson <olof@lixom.net> wrote:
> You should provide a commit message, ideally with a short introduction of the
> platform.

Will do. I was thinking I should do that, this is the first time I
used git format-patch / git send-email.

>> +++ b/arch/arm/configs/moxart_uc7112lx_defconfig
>
> It'd be nice to keep the defconfig generic, and make sure to enable all boards
> in it -- we're generally OK with adding one defconfig per platform upstream but
> not more.

Since MACH_UC7112LX is the only board right now, how can it "enable all boards"?

One way I can think of is to remove CONFIG_MACH_UC7112LX=y from
defconfig and have it (and all future boards) "default y" in
arch/arm/mach-moxart/Kconfig.

I focus on a single hardware, UC-7112-LX. There's at least one more
board with only minor differences (RAM / flash size). But for now,
MACH_UC7112LX is the one I have access to and can test. I think
UC-7110 is already supported, that it would boot, just copy
arch/arm/boot/dts/moxart-uc7112lx.dts and modify ranges for RAM and
MTD. I want to leave this in a state where remaining hardware can
easily be added, albeit by someone that isn't me :)

> If you multiplatform enable this, then you need to have a check in
> moxart_idle_init() to make sure you're running on a moxart soc. Otherwise this
> will still be called and override the arm_pm_idle setting on other platforms as
> well.

I can't find a good example of how other platforms do this, is a DT
lookup an accepted solution? :

static const struct of_device_id moxart_match[] = {
       { .compatible = "moxa,moxart" },
       { }
};

static int __init moxart_idle_init(void)
{
    struct device_node *node;

    node = of_find_matching_node(NULL, moxart_match);
    if (!node)
        return -ENODEV;

    arm_pm_idle = moxart_idle;
    return 0;
}

arch_initcall(moxart_idle_init);


Best regards,
Jonas
