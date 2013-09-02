Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3IBItK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:49:10 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:38819 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3IBItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:49:08 -0400
Message-ID: <522450ED.1020704@synopsys.com>
Date: Mon, 2 Sep 2013 14:18:45 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Michel Lespinasse" <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul Mundt" <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com> <521F662F.4050003@intel.com> <52204E4D.3030602@synopsys.com> <5220B83A.6070709@intel.com>
In-Reply-To: <5220B83A.6070709@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 08:50 PM, Dave Hansen wrote:
> On 08/30/2013 12:48 AM, Vineet Gupta wrote:
>> If we had ARCH_FRAME_POINTER_UNAVAILABLE (def_bool n), we could potentially remove
>> ARCH_FRAME_POINTER too:

>> The issue is some (sparc, c6x...) which are neither in #1 or #2, and not present
>> in anti-dependency list either. e.g. With sparc64_defconfig FP is not present, but
>> if I enable LATENCY_TOP, FP is enabled. For such cases, what do we make default ?
> 
> You can list multiple defaults if you want, or have them depend on other
> config variables:
> 
> config FOO
> 	default BAR
> 
> or
> 
> config FOO
> 	default y if BAR
> 	default n if BAZ
> 
> ARCH_FRAME_POINTER_UNAVAILABLE doesn't make much sense if
> FRAME_POINTER=n, right?  You can have it just plain depend on
> FRAME_POINTER, I think.


I think I was not very clear with the problem description.

With a defbool 'n', FP will be by default enabled and arches not interested in FP
will select ARCH_FRAME_POINTER_UNAVAILABLE. e.g. SPARC, so far so good.

That however means that LATENCYTOP enabled in sparc64_defconfig will now build
with !FP, whereas as of today it enables FP (and SPARC code must be OK with FP
enabling in this config). So, we are changing semantics here, which might still be
OK, but I'll only trust arch maintainers' NOD. So the change is not just
mechanical from that perspective.

My point is, before I cook the patch-set we must be in agreement to this
semantical change.

-Vineet



