Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKIBSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:18:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:54296 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaKIBSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:18:35 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        cryptography@metzdowd.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Subject: libkcapi: First release of kernel crypto API userspace library
Date: Sun, 09 Nov 2014 02:18:28 +0100
Message-ID: <1800633.p8UcYzvYGX@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linux kernel exports a Netlink interface of type AF_ALG to allow user
space to utilize the kernel crypto API.

libkcapi uses this Netlink interface and exports easy to use APIs so that
a developer does not need to consider the low-level Netlink interface 
handling. Its first release is available at [1].

The library does not implement any cipher algorithms. All consumer requests
are sent to the kernel for processing. Results from the kernel crypto API
are returned to the consumer via the library API.

The kernel interface and therefore this library can be used by unprivileged
processes. As the library is small, it may even be included directly into a 
consuming application instead of using it as a shared library.

The library together with the kernel allows the use of symmetric ciphers as 
well as message digests and keyed message digests. Patches are prepared for 
submission to LKML to allow AEAD ciphers and RNGs to be used from userspace.

[1] http://www.chronox.de/libkcapi.html

-- 
Ciao
Stephan
