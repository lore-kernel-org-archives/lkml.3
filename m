Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaAVUmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:42:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58015 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaAVUmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:42:44 -0500
Message-ID: <52E02D40.3090803@wwwdotorg.org>
Date: Wed, 22 Jan 2014 13:42:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 3/5] ARM: firmware: enable Trusted Foundations by default
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com> <1390299016-14105-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1390299016-14105-4-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
> As discussed previously (https://lkml.org/lkml/2013/11/26/289), enable
> Trusted Foundation support by default since it already depends on a
> supporting architecture being selected.
> 
> Doing so allows us to remove it from tegra_defconfig.

>  arch/arm/configs/tegra_defconfig | 1 -
>  arch/arm/firmware/Kconfig        | 1 +

Can we split out the defconfig and code changes into separate patches?
They need to go through seperate branches, possibly even separate repos.

The defconfig change might not even be necessary; at some point I'll
just rebuild it via "make tegra_defconfig; make savedefconfig" on top of
some linux-next that includes the Kconfig change, and it'll happen
automatically. Still, I guess there's no harm explicitly sending the patch.
