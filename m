Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3A2OTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:19:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57745 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3A2OTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:19:21 -0500
Date: Tue, 29 Jan 2013 14:13:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130129141328.GV23505@n2100.arm.linux.org.uk>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 07:30:33PM -0600, Kim Phillips wrote:
> AFAICT, arm gcc got __builtin_bswap{32,64} support in 4.6,
> and for the 16-bit version in 4.8.

Hmm.

$ /usr/local/aeabi/bin/arm-linux-gcc --version
arm-linux-gcc (GCC) 4.5.4
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
$ for a in armv3 armv4 armv4t armv5t armv5te armv6k armv6 armv7-a; do \
   echo $a:; \
   for f in 16 32 64; do \
      echo 'unsigned foo(unsigned val) { return __builtin_bswap'$f'(val); }' | \
      /usr/local/aeabi/bin/arm-linux-gcc -x c -S -o - - -march=$a | grep 'bl'; \
   done; \
done

produces:

armv3:
        bl __builtin_bswap16
armv4:
        bl __builtin_bswap16
armv4t:
        bl __builtin_bswap16
armv5t:
        bl __builtin_bswap16
armv5te:
        bl __builtin_bswap16
armv6k:
        bl __builtin_bswap16
armv6:
        bl __builtin_bswap16
armv7-a:
        bl __builtin_bswap16

So, this compiler (4.5.4) has support for 32-bit and 64-bit bswaps
across all our architectures, but not the 16-bit ones.
