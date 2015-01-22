Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbbAVIHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:07:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbAVIH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:07:28 -0500
Date: Thu, 22 Jan 2015 09:06:47 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] ARM: decompressor: remove unused cache flush code
Message-ID: <20150122080647.GX22880@pengutronix.de>
References: <1421904178-30882-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421904178-30882-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 22, 2015 at 02:22:58PM +0900, Masahiro Yamada wrote:
> As ARM ARM says, the bit 19-16 of ID_MMFR1 is always 0b0000 because
> ARMv7 requires a hierarchical cache implementation.
> The line "mcr    p15, 0, r10, c7, c14, 0" is not reachable.
> 
> Moreover, the v7_flush_dcache_all in arch/arm/mm/cache-v7.S does not
> check the ID_MMFR1.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
I stumbled about this some time ago, too. The thing is however that the
__armv7_mmu_cache functions are selected if
CPUID & 0x000f0000 == 0x000f0000, and that is (AFAIK at present only
theoretically) not implying that we have an ARMv7 machine. Only that it
uses the "CPUID Identification Scheme" which is required on ARMv7.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
