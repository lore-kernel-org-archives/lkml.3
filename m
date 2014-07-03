Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaGCBm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:42:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaGCBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:42:55 -0400
Message-ID: <53B4B51D.2060508@infradead.org>
Date: Wed, 02 Jul 2014 18:42:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kees Cook <kees@outflux.net>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: mmotm 2014-07-02-15-07 uploaded (stack protector)
References: <53b482d3.gR7nYB/K7hPREviI%akpm@linux-foundation.org> <53B493E2.2030905@infradead.org> <20140703005719.GJ5412@outflux.net>
In-Reply-To: <20140703005719.GJ5412@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/14 17:57, Kees Cook wrote:
> Hi Randy,
> 
> And to explain more specifically what's happening:
> 
> On Wed, Jul 02, 2014 at 04:21:06PM -0700, Randy Dunlap wrote:
>> config-r8736:CONFIG_CC_STACKPROTECTOR_STRONG=y
>> [...]
>> build-r8736.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler
>> build-r8736.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler
>> gcc: error: unrecognized command line option '-fstack-protector-strong'
> 
> That makes sense: a feature that requires a specific compiler version was
> chosen, so you get a warning and a failed build. (The first warning was
> during the .config parsing pass, the second warning was during the binary
> build pass.)
> 
>> config-r8737:# CONFIG_CC_STACKPROTECTOR_STRONG is not set
>> [...]
>> build-r8737.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler
> 
> This is the same issue: the prior .config was still there with STRONG set,
> but after finishing the new .config parsing pass, everything is happy for
> the binary build pass. And, I assume, the r8737 didn't fail to build.

True, r8737 built successfully.

Maybe I should use 'make mrproper' instead of 'make clean' between each randconfig
build.

Thanks.

> 
> The trouble seems to be how kbuild handle .config changes, but I was never
> able to sort it out.


-- 
~Randy
