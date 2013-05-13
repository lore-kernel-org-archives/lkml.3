Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3EMPc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:32:29 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41717 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3EMPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:32:28 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Date: Mon, 13 May 2013 17:32:18 +0200
From: Stephan Mueller <smueller@chronox.de>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] CPU Jitter random number generator
Message-ID: <20130513173218.76823730@tauon>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[1] patch at http://www.chronox.de/jent/jitterentropy-20130508.tar.bz2

A new version of the CPU Jitter random number generator is released at
http://www.chronox.de/ . The heart of the RNG is about 30 lines of easy
to read code. The readme in the main directory explains the different
code files.

In a previous attempt (http://lkml.org/lkml/2013/2/8/476), the first
iteration received comments for the lack of tests, documentation and
entropy assessment. All these concerns have been addressed. The
documentation of the CPU Jitter random number generator
(http://www.chronox.de/jent/doc/index.html and PDF at
http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf -- the graphs and
pictures are better in PDF) offers a full analysis of:

- the root cause of entropy

- a design of the RNG

- statistical tests and analyses

- entropy assessment and explanation of the flow of entropy

The document also explains the core concept to have a fully
decentralized entropy collector for every caller in need of entropy.

The appendix of the documentation contains example use cases by
providing link code to the Linux kernel crypto API, libgcrypt and
OpenSSL. Links to other cryptographic libraries should be straight
forward to implement. These implementations follow the concept of
decentralized entropy collection.

The man page provided with the source code explains the use of the API
of the CPU Jitter random number generator.

The test cases used to compile the documentation are available at the
web site as well.

Note: for the kernel crypto API, please read the provided Kconfig file
for the provided switches and which of them are recommended in regular
operation. These switches must currently be set manually in the
Makefile.

Ciao
Stephan

Signed-off-by: Stephan Mueller <smueller@chronox.de>
