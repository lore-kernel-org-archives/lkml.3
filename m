Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaHMFIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:08:23 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60600 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMFIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:08:19 -0400
Date: Wed, 13 Aug 2014 07:08:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.de>, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, msalter@redhat.com,
        a-jacquiot@ti.com, tony.luck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] arch: Kconfig: Let all little endian architectures
 define CPU_LITTLE_ENDIAN explicitly
Message-ID: <20140813050809.GB30459@ravnborg.org>
References: <53EA99C3.90203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EA99C3.90203@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 06:48:35AM +0800, Chen Gang wrote:
> x86 and ia64 are always little endian. And another architectures may be
> little endian: mips, sh, powerpc, and m32r (may mark CPU_LITTLE_ENDIAN
> explicitly); also arm(64) and c6x (which may be !CPU_BIG_ENDIAN).
> 
> Some drivers (e.g. some of "drivers/isdn/hisax") may only support little
> endian (CPU_LITTLE_ENDIAN), and some drivers may only support big endian
> (!CPU_LITTLE_ENDIAN).
> 
> So export all little endian architectures within kernel wide, so can let
> Kconfig easier for the modules which only support little endian or only
> for big endian (assume !CPU_LITTLE_ENDIAN is same as CPU_BIG_ENDIAN).
We need to cover three cases here:
- An arch supports only little endian
- An arch supports only big endian
- An arch may be both little and big endian

The solution you suggest assumes that an arch is either little or big endian.
But we cannot ignore the hybriads that can do both.

	Sam
