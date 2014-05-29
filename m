Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965173AbaE2Pzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:55:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57032 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074AbaE2Pzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:55:39 -0400
Message-ID: <53875876.2020001@wwwdotorg.org>
Date: Thu, 29 May 2014 09:55:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michal Marek <mmarek@suse.cz>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/dtc: pad DTBs to facilitate later modification
References: <1400888507-11637-1-git-send-email-khilman@linaro.org>
In-Reply-To: <1400888507-11637-1-git-send-email-khilman@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 05:41 PM, Kevin Hilman wrote:
> By default, add some padding to the DT blobs to facilitate later
> patching.
> 
> An example need for DTB patching is the need to modifiy the command
> line on platforms where ATAGS are not (or cannot) be used to pass the
> commandline.  For example, we do not support a big-endian kernel
> reading ATAGS from a little-endian u-boot, so the only way to pass a
> command line in the DT.
> 
> Also, without ATAG support (or if u-boot was built without
> CONFIG_INITRD_TAG) the only way to pass an initrd is by adding an
> initrd= option to command line (in the DT).
> 
> Therefore, to facilitate adding to the DT command line directly in the
> DTB, add some padding.
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> I kinda pulled 64 bytes out of the air here since it's enough to add
> some common things to the commandline like debug, earlyprink
> initrd=<addr>,<size>, etc., but I'm certainlly not opposed to more
> padding.

Conceptually,
Acked-by: Stephen Warren <swarren@nvidia.com>

But I would expect a pad of something like 4KB to be more future-proof.
U-Boot appears to use 4KB on ARM at least:

./arch/arm/dts/Makefile:37:DTC_FLAGS += -R 4 -p 0x1000
