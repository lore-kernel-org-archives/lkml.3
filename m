Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaDPXk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:40:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35968 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaDPXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:40:57 -0400
X-Auth-Info: Mgsb6lVZL0JUeyZf/0mPA2E0JZSivMK5MhTxpl1uB6w=
From: Marek Vasut <marex@denx.de>
To: Austin Boyle <boyle.austin@gmail.com>
Subject: Re: [PATCH v3] mtd: m25p80: Calculate flash block protect bits based on number of sectors
Date: Thu, 17 Apr 2014 01:22:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Brian Norris <computersforpeace@gmail.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Angus Clark <angus.clark@st.com>
References: <alpine.DEB.2.02.1404162227120.3848@austin-Satellite-L510>
In-Reply-To: <alpine.DEB.2.02.1404162227120.3848@austin-Satellite-L510>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404170122.20996.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 at 02:37:13 PM, Austin Boyle wrote:
> This patch generalises the calculation of block protect bits based on the
> number of sectors and implements the _is_locked function.
> 
> Existing calculation of block protect bits only works for devices with 64
> sectors or more. This new logic is applicable to the STmicro devices:
> m25p10, p20, p40, p80, p16, pe16, p32, p64, p128.
> Note devices with >64 sectors only allow the protected region to be
> specified to a resolution of 1/64th of the total size (such as m25p64).
> 
> New return codes for ioctl(MEMISLOCKED) have been added to
> uapi/mtd/mtd-abi.h because the _is_locked function can query a region
> which is partially unlocked.
> 
> Added flag to m25p_ids table to indicate if flash protection is supported.
> 
> Added n_sectors and sector_size to m25p flash structure so it can be used
> in block protect bit calculation.
> 
> From: Austin Boyle <boyle.austin@gmail.com>
> Signed-off-by: Austin Boyle <boyle.austin@gmail.com>

Acked-by: Marek Vasut <marex@denx.de>

Thanks!

Best regards,
Marek Vasut
