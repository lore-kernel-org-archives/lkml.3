Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbbAXQtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:49:22 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:51862 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbbAXQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:49:19 -0500
Message-ID: <1422118156.27947.7.camel@x220>
Subject: Re: [PATCH 0/4] defconfigs: cleanup obsolete MTD configs
From: Paul Bolle <pebolle@tiscali.nl>
To: Semen Protsenko <semen.protsenko@globallogic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Russell King <linux@arm.linux.org.uk>,
        adi-buildroot-devel@lists.sourceforge.net, linux-am33-list@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org
Date: Sat, 24 Jan 2015 17:49:16 +0100
In-Reply-To: <1422117213-3130-1-git-send-email-semen.protsenko@globallogic.com>
References: <1422117213-3130-1-git-send-email-semen.protsenko@globallogic.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2015 16:49:16.0411 (UTC) FILETIME=[B0A8C4B0:01D037F5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-24 at 18:33 +0200, Semen Protsenko wrote:
> This patch series removes next obsolete MTD configs from all defconfig files:
>   - CONFIG_MTD_CHAR
>   - CONFIG_MTD_CONCAT
>   - CONFIG_MTD_DEBUG
>   - CONFIG_MTD_DEBUG_VERBOSE
>   - CONFIG_MTD_PARTITIONS
> 
> All those configs were removed from drivers/mtd/Kconfig earlier, but their usage
> in defconfig files was remain unnoticed. There are at least two obvious reasons
> to get rid of those configs:
>   1. Their usage may cause to build warnings

That's news for me. I thought they are silently ignored. Do you have an
example of such a warning?

>   2. Their usage may confuse someone who is grepping defconfig files to get
>      the clue what MTD configuration may look like.
> 
> This series is harmless for all those defconfigs and will not break anything.
> 
> 
> Semen Protsenko (4):
>   defconfigs: remove CONFIG_MTD_CONCAT
>   defconfigs: remove CONFIG_MTD_PARTITIONS
>   defconfigs: remove CONFIG_MTD_CHAR
>   defconfigs: remove CONFIG_MTD_DEBUG*
> 
>  arch/arm/configs/acs5k_defconfig                   |    3 ---
> [...]
>  arch/unicore32/configs/unicore32_defconfig         |    2 --
>  226 files changed, 364 deletions(-)

Seems like the kind of change that can only be reviewed by a script.

Is there any policy on keeping defconfig files up to date? Because, only
slightly exaggerated, all the defconfig files are outdated, in minor or
major ways, at any given moment.

I seem to remember Greg stating that defconfig files are on their way
out. Did I remember that correctly?  


Paul Bolle

