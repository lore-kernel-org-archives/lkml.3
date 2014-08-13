Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaHMGzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:55:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51246 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaHMGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:55:16 -0400
Message-ID: <53EB0AF6.6060208@zytor.com>
Date: Tue, 12 Aug 2014 23:51:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
CC: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.de>, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, msalter@redhat.com,
        a-jacquiot@ti.com, tony.luck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] arch: Kconfig: Let all little endian architectures
 define CPU_LITTLE_ENDIAN explicitly
References: <53EA99C3.90203@gmail.com> <20140813050809.GB30459@ravnborg.org> <53EAF85E.3000208@gmail.com>
In-Reply-To: <53EAF85E.3000208@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 10:32 PM, Chen Gang wrote:
> 
> Yeah, we need.
> 
>> The solution you suggest assumes that an arch is either little or big endian.
>> But we cannot ignore the hybriads that can do both.
>>
> 
> For the architectures which can do both, for me, they are: sh, powerpc,
> m32r, and mips (may mark CPU_LITTLE_ENDIAN), also are: arm/arm64, and
> c6x (may mark !CPU_BIG_ENDIAN).
> 
> For the architectures which only support little endian: x86, and ia64.
> 
> The left, I assumes they are big endian (no any 'ENDIAN' can be found
> in their Kconfig files). In my memory, except related with Intel, all
> are (or support) big endian.
> 

I'm quite certain that is wrong.  From memory, for example, I believe
CRIS is littleendian, and sure enough:

: tazenda 103 ; less arch/cris/include/uapi/asm/byteorder.h
#ifndef _CRIS_BYTEORDER_H
#define _CRIS_BYTEORDER_H

#include <linux/byteorder/little_endian.h>

#endif

As far as I know, endianism is always a compile-time option on Linux, so
we should be able to relatively easily define the architecture so that
we either have hardwired littleendian, bigendian, or prompt.

	-hpa

