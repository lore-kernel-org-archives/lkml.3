Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaJLKIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 06:08:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:57329 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaJLKIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 06:08:46 -0400
Date: Sun, 12 Oct 2014 12:08:37 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Carlos O'Donell" <carlos@systemhalted.org>
Subject: [GIT PULL] parisc architecture patch for v3.18
Message-ID: <20141012100837.GA1553@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:l0x/AT/7p4BP7jkQtAPXvcvbGyTKMp7SxbfLINuuT2ooRbwkLbX
 a9Kjhd/oahf5Nvv0/31ZlNjfi2roMU74k4Q1lMVUqBQstBb7ngZ3aIhx99fqLys0agxriyl
 DhUdmGkh4cH20iluYhnNx7jdeRve/VMOXAWc/fjPuSqp+6HdAibu9FZDK08VnTtc3gkzTfV
 GQlmGoc2aNMVKH1nM82mw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull one patch for the parisc architecture for kernel 3.18 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.18-1

This patch intentionally breaks the ABI on PARISC Linux!

It assigns new numbers to SIGSTKFLT, SIGXCPU, SIGXFSZ and SIGSYS so that
those are below 32 and thus leaves us with 32 RT signals like other
Linux architectures (SIGRTMIN now becomes 32 instead of 37).

Even if it breaks the ABI, it doesn't seem to have any visible impact on
existing userspace applications. I was able to mix new kernel and/or
glibc without impacting normal bootup.  So, even if it breaks the ABI,
the benefits (e.g. being able to use systemd on PARISC Linux)
outperforms the minimal (if any) impact it gives.

The patch has been discussed on the parisc kernel mailing list and the
coresponding glibc patch will be committed by the parisc glibc
maintainer after this patch went into 3.18.

Some more background information about this patch is in the commit
message.

Thanks,
Helge 

----------------------------------------------------------------
Helge Deller (1):
      parisc: Reduce SIGRTMIN from 37 to 32 to behave like other Linux architectures

 arch/parisc/include/uapi/asm/signal.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)
