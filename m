Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3GTQAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:00:45 -0400
Received: from mail.tomasu.net ([64.85.170.232]:37260 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab3GTQAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:00:45 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: compile error on 3.10.1
Date: Sat, 20 Jul 2013 09:59:57 -0600
Message-ID: <36183925.Z4AeQk3t4j@balsa>
User-Agent: KMail/4.10.5 (Linux/3.9-1-amd64; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, just trying to compile a vanilla kernel and building using
allmodconfig and using oldconfig with the debian 3.10.1 config as a base.

With the later config, I get the following:

  CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_print_ringâ:
drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer targets in 
passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
Werror=pointer-sign]
           false);
           ^
In file included from include/linux/kernel.h:13:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/net/wireless/ath/wil6210/debugfs.c:17:
include/linux/printk.h:361:13: note: expected âchar *â but argument is of type 
âunsigned char *â
 extern void hex_dump_to_buffer(const void *buf, size_t len,
             ^
drivers/net/wireless/ath/wil6210/debugfs.c: In function 
âwil_txdesc_debugfs_showâ:
drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer targets in 
passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
Werror=pointer-sign]
          sizeof(printbuf), false);
          ^
In file included from include/linux/kernel.h:13:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/net/wireless/ath/wil6210/debugfs.c:17:
include/linux/printk.h:361:13: note: expected âchar *â but argument is of type 
âunsigned char *â
 extern void hex_dump_to_buffer(const void *buf, size_t len,
             ^
cc1: all warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

There are also a bunch of warnings, most of the ones I could catch are
signedness related.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
