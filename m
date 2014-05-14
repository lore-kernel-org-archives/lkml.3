Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaENDp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:45:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51137 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaENDpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:45:55 -0400
Message-ID: <5372E6F0.1050604@wwwdotorg.org>
Date: Tue, 13 May 2014 21:45:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        =?ISO-8859-1?Q?Andreas_F=E4?= =?ISO-8859-1?Q?rber?= 
	<afaerber@suse.de>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com> <536A57FA.2090608@wwwdotorg.org> <536AC45F.6080608@nvidia.com> <536CE414.5030406@suse.de> <536CF33A.3020906@wwwdotorg.org> <53727D9E.9050800@suse.de> <5372CE37.1080601@nvidia.com>
In-Reply-To: <5372CE37.1080601@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 08:00 PM, Alexandre Courbot wrote:
...
> Both SHIELD and TN7 come with a locked bootloader and cannot use U-boot.
> The bootloader can only boot a kernel from a dedicated, raw boot
> partition (Android style), can only pass a device tree from another raw
> "dtb" partition, and will fill it with plenty of dirty command-line
> options that make mainline unusable. That seems to be a lot for distros
> to handle, so at this stage we'd rather advise users to use a root FS
> image of their favorite distro along with a self-compiled kernel.

I don't know how much effort it's worth putting into this, but it
/might/ be possible to port U-Boot to the devices, and use that as the
"kernel" image that the binary bootloader boots, and then have U-Boot
boot a kernel from a filesystem in the "normal" way. That's kind what I
did by porting U-Boot to the Raspberry Pi. It would certainly increase
the possibility of a distro supporting these devices in a generic way,
as well as avoiding the need for hard-coded command-lines, memory
layout, etc. in the DT files. We'd have to make sure that any installer
didn't change the GPT layout, since then it'd get out of sync with the
tegrapt partitions, which could cause the bootloader to fail.
