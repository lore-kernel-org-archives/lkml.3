Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaBSVSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:18:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44841 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaBSVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:18:34 -0500
Message-ID: <53051FD2.1020905@windriver.com>
Date: Wed, 19 Feb 2014 16:19:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/tty/serial: deal with 8250_core.c uninitialized
 warning for good
References: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com> <1392843083.11798.74.camel@acox1-desk.ger.corp.intel.com>
In-Reply-To: <1392843083.11798.74.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-19 03:51 PM, Alan Cox wrote:
> On Wed, 2014-02-19 at 15:00 -0500, Paul Gortmaker wrote:
>> Every couple of months, someone sends a patch to fix:
>>
>> drivers/tty/serial/8250/8250_core.c: In function 'serial_unlink_irq_chain':
>> drivers/tty/serial/8250/8250_core.c:1712:2: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
>>
>> and they in turn get a NACK for their efforts, and are told that
>> their compiler is broken.  This has been going on since at least
>> the year 2008:  https://lkml.org/lkml/2008/11/24/433
>>
>> Lets add a comment, so that subsequent patches don't get as far as
>> the maintainers or the mailing lists.
> 
> Are people still using gcc variants that get this wrong ?

It seems that gcc 4.6.3 gets it wrong, and it isn't _that_ old.

Paul.
--

$ mips-linux-gcc -v
Using built-in specs.
COLLECT_GCC=mips-linux-gcc
COLLECT_LTO_WRAPPER=/home/paul/tc/gcc-4.6.3-nolibc/mips-linux/bin/../libexec/gcc/mips-linux/4.6.3/lto-wrapper
Target: mips-linux
Configured with: /home/tony/buildall/src/gcc/configure --target=mips-linux --host=x86_64-linux-gnu --build=x86_64-linux-gnu --enable-targets=all --prefix=/opt/cross/gcc-4.6.3-nolibc/mips-linux/ --enable-languages=c --with-newlib --without-headers --enable-sjlj-exceptions --with-system-libunwind --disable-nls --disable-threads --disable-shared --disable-libmudflap --disable-libssp --disable-libgomp --disable-decimal-float --enable-checking=release --with-mpfr=/home/tony/buildall/src/sys-x86_64 --with-gmp=/home/tony/buildall/src/sys-x86_64 --disable-bootstrap --disable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC) 
$ make allmodconfig > /dev/null
$ make drivers/tty/serial/8250/8250_core.o > /dev/null
drivers/tty/serial/8250/8250_core.c: In function 'serial_unlink_irq_chain':
drivers/tty/serial/8250/8250_core.c:1712:2: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
$ 


> 
> Fine by me.
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> 
