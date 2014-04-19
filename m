Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaDSOmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:42:17 -0400
Received: from lekensteyn.nl ([178.21.112.251]:41691 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaDSOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:42:13 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Steinmetz <ast@domdv.de>
Subject: aes-x86_64 seems slower than the generic implementation
Date: Sat, 19 Apr 2014 16:42:07 +0200
Message-ID: <2046035.alMyLlD0ki@al>
User-Agent: KMail/4.13 (Linux/3.15.0-rc1-custom-00356-gebfc45e; KDE/4.13.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

When comparing the x86_64 assembly implementation (module aes-x86_64) against 
the generic AES implementation, I found that the generic implementation was 
consistenly faster.

Test setup #1:

 * cryptsetup 1.6.4
 * Linux v3.15-rc1-356-gebfc45e,
   https://github.com/Lekensteyn/aur/blob/1d1950/linux-custom/config
 * CPU: Intel i5-460M
 * Distro: Arch Linux x86_64

Command:

   for i in {0..10};do cryptsetup benchmark --cipher aes-xts; done

Test results for n=11, mean (+ standard deviation), enc/dec:

 * aes-x86_64:  139.6 (0.68) / 138.5 (0.22)
 * aes-generic: 144.8 (0.63) / 144.6 (0.31)


About a month ago, I conducted a similar test on a different machine[1].

 * cryptsetup 1.6.4
 * QEMU: 1.7.0
 * Linux (guest, no modules): v3.14-rc7-59-g08edb33
 * Linux (host): v3.14-rc5
 * CPU: Intel i7-3770

Test results comparing aes-generic, aes-x86_64 and AESNI (n=3):

                   generic     x86_64      aesni
 * aes-cbc-128     201/276     200/280     669/2500
 * aes-cbc-256     162/205     159/208     492/1835
 * aes-xts-256     275/270     272/276     2050/2034
   (note, AES-NI performance varies a lot)

Aren't the assembly implementations supposed to be faster?

Kind regards,
Peter
 
 [1]: https://lekensteyn.nl/files/linux-crypto-benchmark/

