Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3H3PUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:20:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:9456 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab3H3PUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,991,1367996400"; 
   d="scan'208";a="353890163"
Message-ID: <5220B83A.6070709@intel.com>
Date: Fri, 30 Aug 2013 08:20:26 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com> <521F662F.4050003@intel.com> <52204E4D.3030602@synopsys.com>
In-Reply-To: <52204E4D.3030602@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 12:48 AM, Vineet Gupta wrote:
> If we had ARCH_FRAME_POINTER_UNAVAILABLE (def_bool n), we could potentially remove
> ARCH_FRAME_POINTER too:
> 
> 1. arches which explicitly select ARCH_FRAME_POINTER (xtensa, parisc, arm64, x86,
> unicore32, tile) could just drop that select.
> 
> 2. Others which add themselves to config FRAME_POINTER depends on (CRIS, M68K,
> FRV, UML, AVR32, SUPERH, BLACKFIN, MN10300, METAG) can simply be removed form that
> list.
> 
> 3. Other who want to inhibit FP obviously select it (MIPS, PPC, S390, MICROBLAZE,
> ARM_UNWIND, ARC)

That all seems sane to me.

> The issue is some (sparc, c6x...) which are neither in #1 or #2, and not present
> in anti-dependency list either. e.g. With sparc64_defconfig FP is not present, but
> if I enable LATENCY_TOP, FP is enabled. For such cases, what do we make default ?

You can list multiple defaults if you want, or have them depend on other
config variables:

config FOO
	default BAR

or

config FOO
	default y if BAR
	default n if BAZ

ARCH_FRAME_POINTER_UNAVAILABLE doesn't make much sense if
FRAME_POINTER=n, right?  You can have it just plain depend on
FRAME_POINTER, I think.
