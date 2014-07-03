Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaGCA5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:57:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34351 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbaGCA5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:57:47 -0400
Date: Wed, 2 Jul 2014 17:57:19 -0700
From: Kees Cook <kees@outflux.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: mmotm 2014-07-02-15-07 uploaded (stack protector)
Message-ID: <20140703005719.GJ5412@outflux.net>
References: <53b482d3.gR7nYB/K7hPREviI%akpm@linux-foundation.org>
 <53B493E2.2030905@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B493E2.2030905@infradead.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

And to explain more specifically what's happening:

On Wed, Jul 02, 2014 at 04:21:06PM -0700, Randy Dunlap wrote:
> config-r8736:CONFIG_CC_STACKPROTECTOR_STRONG=y
> [...]
> build-r8736.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler
> build-r8736.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler
> gcc: error: unrecognized command line option '-fstack-protector-strong'

That makes sense: a feature that requires a specific compiler version was
chosen, so you get a warning and a failed build. (The first warning was
during the .config parsing pass, the second warning was during the binary
build pass.)

> config-r8737:# CONFIG_CC_STACKPROTECTOR_STRONG is not set
> [...]
> build-r8737.out:/local/lnx/MM/mmotm-2014-0702-1507/Makefile:662: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: -fstack-protector-strong not supported by compiler

This is the same issue: the prior .config was still there with STRONG set,
but after finishing the new .config parsing pass, everything is happy for
the binary build pass. And, I assume, the r8737 didn't fail to build.

The trouble seems to be how kbuild handle .config changes, but I was never
able to sort it out.

-Kees

-- 
Kees Cook                                            @outflux.net
