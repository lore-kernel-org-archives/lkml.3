Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaHQP4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:56:03 -0400
Received: from mail.eperm.de ([89.247.134.16]:51239 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaHQP4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:56:01 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Kernel crypto API: cryptoperf performance measurement
Date: Sun, 17 Aug 2014 17:55:51 +0200
Message-ID: <56334718.JSiBY74glM@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during playing around with the kernel crypto API, I implemented a performance 
measurement tool kit for the various kernel crypto API cipher types. The 
cryptoperf tool kit is provided in [1].

Comments are welcome.

In general, the results are as expected, i.e. the assembler implementations 
are faster than the pure C implementations. However, there are curious results 
which probably should be checked by the maintainers of the respective ciphers 
(hoping that my tool works correctly ;-) ):

ablkcipher
----------

- cryptd is slower by factor 10 across the board

blkcipher
---------

- Blowfish x86_64 assembler together with the generic C block chaining modes 
is significantly slower than Blowfish implemented in generic C

- Blowfish x86_64 assembler in ECB is significantly slower than generic C 
Blowfish ECB

- Serpent assembler implementations are not significantly faster than generic 
C implementations

- AES-NI ECB, LRW, CTR is significantly slower than AES i586 assembler.

- AES-NI ECB, LRW, CTR is not significantly faster than AES generic C

rng
---

- The ANSI X9.31 RNG seems to work massively faster than the underlying AES 
cipher (by about a factor of 5). I am unsure about the cause of this.


Caveat
------

Please note that there is one small error which I am unsure how to fix it as 
documented in the TODO file.

[1] http://www.chronox.de/cryptoperf.html

-- 
Ciao
Stephan
