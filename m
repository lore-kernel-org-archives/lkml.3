Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHBCSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 22:18:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60556 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaHBCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 22:17:59 -0400
Message-ID: <53DC4A4F.8060009@collabora.co.uk>
Date: Sat, 02 Aug 2014 04:17:51 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 05/10] ARM: dts: Fill in bootargs for exynos5250-snow
References: <1406940750-15880-1-git-send-email-afaerber@suse.de> <1406940750-15880-6-git-send-email-afaerber@suse.de>
In-Reply-To: <1406940750-15880-6-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

Sorry for missing your v5.

On 08/02/2014 02:52 AM, Andreas Färber wrote:
>  
>  	chosen {
> +		bootargs = "console=tty1";
>  	};

While I agree with you that having a chosen node with a default bootargs is
better than having an empty one, I second Doug that this bootargs is not very
useful.

If you want to add a bootargs in the DTS I think that it should be a complete
kernel command line that allows to boot a system. I would at least add a root
parameter and possibly another console for the serial port. So if
CMDLINE_FROM_BOOTLOADER is not set then the DT can be used to specify the
bootargs instead of using whatever was set in CONFIG_CMDLINE which probably
won't be relevant for every system on a multi-platform kernel.

But I think that is safe to rely on the bootloader to set the bootargs and after
all having a hardcoded bootargs in the DTS is not much better than having a
hardcoded CONFIG_CMDLINE since as Doug said it is hard to make assumptions about
what would be the most common options.

Personally I would just drop this change and as I said before remove the empty
chosen node on a follow up patch but I don't have a strong opinion either.

Best regards,
Javier
