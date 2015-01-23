Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbbAWPcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:32:10 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:61177 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbAWPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:32:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sergey Dyasly <s.dyasly@samsung.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ARM: use default ioremap alignment for SMP or LPAE
Date: Fri, 23 Jan 2015 16:31:51 +0100
Message-ID: <52689548.6W7Vnxiz8L@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150123145235.GB21789@e104818-lin.cambridge.arm.com>
References: <1421911075-8814-1-git-send-email-s.dyasly@samsung.com> <3060178.HEZJjJCl1e@wuerfel> <20150123145235.GB21789@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:FfP5ze5QJuCHh6ypMz0IEqbHZx/taqHOXO6i2g7i/duyd66Hkax
 oy/zPwF0rKRb4h7mWFmxqL0isWeXCDzWNH4+RxbAdoCyEIn3aWB3mzykPw9QA7SCE+EW0NN
 pTsTTtgTueN7Cg+fsGBI7Hyd3+UMI+AaE5BMdwpXgQt17G9uNMLuTlhiYDnV8Zb0CSW83bj
 hQ4zL90N2poT7wvwFyuTw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2015 14:52:36 Catalin Marinas wrote:
> On Thu, Jan 22, 2015 at 11:03:00AM +0000, Arnd Bergmann wrote:
> > Unrelated to this question however is whether we want to keep
> > supersection mappings as a performance optimization to save TLBs.
> > It seems useful to me, but not critical.
> 
> Currently in Linux we allow 16MB mappings only if the phys address is
> over 32-bit and !LPAE which makes it unlikely for normal RAM with
> pre-LPAE hardware.

Ah, I missed this part when looking at the code.

> IIRC a bigger problem was that supersections are optional in the
> architecture but there was no CPUID bit field in ARMv6 (and early ARMv7)
> to check for their presence. The ID_MMFR3 contains this information but
> for example on early Cortex-A8 that bitfield was reserved and the TRM
> states "unpredictable" on read (so probably zero in practice).
> 
> On newer ARMv7 (not necessarily with LPAE), we could indeed revisit the
> 16MB section mapping but it won't go well with single zImage if you want
> to support earlier ARMv7 or ARMv6.

I see. If there is desire to have it as an optimization, we could do
it for armv7ve-only kernels. We don't currently have an build-time
option for those, but we should introduce one anyway, in order to
better make use of the idiv instructions and to prevent one from
enabling LPAE on a multiplatform kernel that contains pre-lpae armv7
machines (Cortex a8/a9/a5, and some others I'm not sure about).

	Arnd
