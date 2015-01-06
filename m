Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbbAFRIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:08:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44968 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbAFRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:08:20 -0500
Message-ID: <54AC16B0.5050703@wwwdotorg.org>
Date: Tue, 06 Jan 2015 10:09:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: rely on bootloader pinmux programming
 on nyan-big
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com> <1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1420540653-14816-2-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:37 AM, Tomeu Vizoso wrote:
> Following 6dbaff2b, the kernel expects that the bootloader has correctly
> programmed the Tegra pinmux.
>
> DTs for the Jetson and the Venice2 had been updated already but this one
> was left behind.

So this setup is true for NVIDIA-controlled development/reference boards 
where we've ensured that the bootloader sets up 100% of the pinmux.

However, I know that Coreboot on this board doesn't set up everything in 
the pinmux, and since it's in r/o flash never will. As such, I'm not 
sure this change is safe for this board. That is, unless you want to 
force upstream kernels to be booted via a chain-loaded path: Coreboot 
(r/o) -> U-Boot (r/w with full pinmux setup) -> kernel.

> Have tested this with the stock vendor firmware (coreboot) and have found no
> issues.

There are presumably a bunch of features which aren't yet supported 
upstream, and hence you couldn't test though? That means we might find 
that parts of the pinmux aren't yet programmed but need to be to enable 
those features.
