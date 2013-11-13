Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3KMQec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:34:32 -0500
Received: from c60.cesmail.net ([216.154.195.49]:8607 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab3KMQe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:34:28 -0500
Date: Wed, 13 Nov 2013 11:34:18 -0500
From: Pavel Roskin <proski@gnu.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Uncompressed kernel doesn't build on x86_64
Message-ID: <20131113113418.167b8ffd@IRBT4585>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Your recent patch enables uncompressed kernels, but selecting that
option (CONFIG_KERNEL_UNCOMPRESSED) fails on x86_86:

commit 69f0554ec261fd686ac7fa1c598cc9eb27b83a80
Author: Christian Ruppert <christian.ruppert@abilis.com>
Date:   Tue Nov 12 15:11:43 2013 -0800

    init/Kconfig: add option to disable kernel compression

That's how it fails:

  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
  VOFFSET arch/x86/boot/voffset.h
make[4]: *** No rule to make target
  `arch/x86/boot/compressed/vmlinux.bin.', needed by
  `arch/x86/boot/compressed/piggy.S'.  Stop. make[3]: ***
  [arch/x86/boot/compressed/vmlinux] Error 2 make[2]: *** [bzImage]
  Error 2 make[1]: *** [sub-make] Error 2 make: *** [all] Error 2

arch/x86/boot/compressed/Makefile has no provision for uncompressed
files.  There is no definition for suffix-$(CONFIG_KERNEL_UNCOMPRESSED)
so $(suffix-y) evaluates to an empty string and there is no rule to
make vmlinuz.bin.$(suffix-y)

I think the patch should be either reverted or fixed as soon as
possible.

Any suggestions for uncompressed suffix?  I'd go with "copy".  Then the
"compression" could be a symlink.  Alternatively, the "." could be
included in other suffixes, the uncompressed suffix would be empty and
the compression would be an empty statement.

-- 
Regards,
Pavel Roskin
