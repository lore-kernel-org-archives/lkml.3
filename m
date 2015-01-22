Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbbAVPog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:44:36 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:46323 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbAVPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:44:30 -0500
Date: Thu, 22 Jan 2015 15:44:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Heiko Stuebner <heiko@sntech.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: decompressor: remove unused cache flush code
Message-ID: <20150122154400.GB26493@n2100.arm.linux.org.uk>
References: <1421904178-30882-1-git-send-email-yamada.m@jp.panasonic.com>
 <20150122080647.GX22880@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150122080647.GX22880@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 09:06:47AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Jan 22, 2015 at 02:22:58PM +0900, Masahiro Yamada wrote:
> > As ARM ARM says, the bit 19-16 of ID_MMFR1 is always 0b0000 because
> > ARMv7 requires a hierarchical cache implementation.
> > The line "mcr    p15, 0, r10, c7, c14, 0" is not reachable.
> > 
> > Moreover, the v7_flush_dcache_all in arch/arm/mm/cache-v7.S does not
> > check the ID_MMFR1.
> > 
> > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> I stumbled about this some time ago, too. The thing is however that the
> __armv7_mmu_cache functions are selected if
> CPUID & 0x000f0000 == 0x000f0000, and that is (AFAIK at present only
> theoretically) not implying that we have an ARMv7 machine. Only that it
> uses the "CPUID Identification Scheme" which is required on ARMv7.

Correct, and there are ARMv6 CPUs which satisfy the "CPUID identification
scheme" test - and are probably not heirarchial.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
