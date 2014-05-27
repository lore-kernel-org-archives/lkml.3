Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaE0FEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:04:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaE0FEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:04:50 -0400
Message-ID: <53841CED.9010800@infradead.org>
Date: Mon, 26 May 2014 22:04:45 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
CC: "T. Makphaibulchoke" <tmac@hp.com>,
        Andreas Gruenbacher <a.gruenbacher@computer.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.15-rc6  build / link failed  fs/built-in  mb_cache_entry problems
References: <redirect-87012843@zbackend1.aha.ru>
In-Reply-To: <redirect-87012843@zbackend1.aha.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 11:17 AM, werner wrote:
> building the kernel isnt successful,
> 
> problem with _mbècache_entry_release and _get
> 
> see below
> 
> there are also other errors
> 
> 
> The whole compiler list and config, see enclosed
> 
> 

First of all, my build using your kernel config file builds -- no errors,
just plenty of warnings.  I am using gcc version 4.7.2.  What gcc version
are you using?

mbcache.c uses __builtin_log2().  Maybe your gcc version does not support
that builtin function.

@tmac:  can mbcache.c #include <linux/log2.h> and use ilog2(NR_BG_LOCKS)
instead of using __builtin_log2(NR_BG_LOCKS) ?
(ref. commit ID 1f3e55fe02d12213f87869768aa2b0bad3ba9a7d)


> 
> 
> Since appr 3.10 ,  even if the kernels compile and build , on meanwhile 70% of the computers where I try to boot, the booting process crashs on different positions.

Please use return/line feed every 70-72 characters instead of assuming that
all email clients will display the text correctly.  They don't.

> 
> Currently, the quality is rather bad, similar as it was during the versions  2.6.30 ... 36 .
> 
> So it would be good, if the programmers would check everything more careful   (im not a programmer but only an user)
> 
> Enclosed is a compiling list, someone could see through this, and correct all problems, such as mismatches, undefined variables, etc
> 
> 
> W.Landgraf
> 
> 
> 
> 
> 
> ..
> 
> fs/built-in.o: In function `__mb_cache_entry_release':
> mbcache.c:(.text+0xa0d5f): undefined reference to `log2'
> mbcache.c:(.text+0xa0d6b): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0xa0e22): undefined reference to `log2'
> mbcache.c:(.text+0xa0e34): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0xa0f4e): undefined reference to `log2'
> mbcache.c:(.text+0xa0f60): undefined reference to `__fixunsdfsi'
> fs/built-in.o: In function `__mb_cache_entry_find':
> mbcache.c:(.text+0xa107e): undefined reference to `log2'
> mbcache.c:(.text+0xa108a): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0xa115c): undefined reference to `log2'
> mbcache.c:(.text+0xa116e): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0xa11dc): undefined reference to `log2'
> mbcache.c:(.text+0xa11e8): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0xa126e): undefined reference to `log2'
> mbcache.c:(.text+0xa1280): undefined reference to `__fixunsdfsi'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3bdc): undefined reference to `log2'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3bf1): undefined reference to `__fixunsdfsi'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3d14): undefined reference to `log2'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3d26): undefined reference to `__fixunsdfsi'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3da7): undefined reference to `log2'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3db3): undefined reference to `__fixunsdfsi'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3e5e): undefined reference to `log2'
> fs/built-in.o: In function `mb_cache_entry_get':
> (.text+0xa3e70): undefined reference to `__fixunsdfsi'
> make: [vmlinux] Error 1 (ignored)



-- 
~Randy
