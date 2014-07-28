Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaG1Qj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:39:58 -0400
Received: from smtp-out-003.synserver.de ([212.40.185.3]:1053 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaG1Qjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:39:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1380
Message-ID: <53D67CD2.9040200@metafoo.de>
Date: Mon, 28 Jul 2014 18:39:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        Andreas Olofsson <andreas@adapteva.com>, linux-kernel@vger.kernel.org,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <53D677B1.2000700@suse.de>
In-Reply-To: <53D677B1.2000700@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 06:17 PM, Andreas Färber wrote:
> Hi Lars-Peter,
>
> Am 25.07.2014 01:00, schrieb Andreas Färber:
>> most notably I'm missing
>> ADI ADV7513 and AXI-HDMI support
> [...]
>> Cc: Lars-Peter Clausen <lars@metafoo.de> (HDMI)
>
> Could you please enlighten us what the status of upstreaming
> ADV7511/ADV7513 support is? It is declared "work in progress" here:
>
> http://wiki.analog.com/resources/tools-software/linux-drivers/drm/adv7511
>
> I see some adv7511 V4L bits in drivers/media/i2c/adv7511.c, but no
> drivers/gpu/drm/i2c/adv7511_{core,audio}.c as on the xcomm_zynq branch,
> nor any devicetree documentation. Patchwork doesn't show any recent
> submissions to LKML.
>
> Is any major rework needed for you to get the 3.14.12 based driver upstream?
>

It's complicated. The plan for the driver was to wait for the common display 
framework (CDF) and convert it to use CDF and then submit it upstream. The 
CDF has been rejected though. Meanwhile the V4L2 adv7511 driver has been 
merged. So now we are in the ugly situation that we have two different 
drivers for two different frameworks. To fix this we need to merge these two 
drivers while still exposing the interfaces to both frameworks.

> AXI SPDIF I found in 3.16, as you noticed; what about AXI HDMI? [*]
> Is there any work ongoing to get that upstream as well?

We need to teach the DMAengine framework about cyclic interleaved transfers 
before the AXI HDMI driver can be submitted upstream.

- Lars

