Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3AKHRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:17:19 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:38977 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3AKHRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:17:17 -0500
Date: Fri, 11 Jan 2013 09:17:10 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: 3.8-rc3: yet another MIPS build failure
Message-ID: <20130111071710.GE12712@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit d3ce88431892b703b04769566338a89eda6b0477 (MIPS: Fix modpost
error in modules attepting to use virt_addr_valid()) broke the 64-bit
MIPS build:

  LD      init/built-in.o
kernel/built-in.o: In function `memory_bm_free':
snapshot.c:(.text+0x3c76c): undefined reference to `__virt_addr_valid'
snapshot.c:(.text+0x3c800): undefined reference to `__virt_addr_valid'
kernel/built-in.o: In function `snapshot_write_next':
(.text+0x3e094): undefined reference to `__virt_addr_valid'
kernel/built-in.o: In function `snapshot_write_next':
(.text+0x3e468): undefined reference to `__virt_addr_valid'
make[4]: *** [vmlinux] Error 1

A quick workaround is to compile ioremap.c always, but it adds ~2KB
unused code for 64-bit-only kernels...

A.
