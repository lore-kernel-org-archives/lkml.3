Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3KKTvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:51:38 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:64574 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3KKTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:51:25 -0500
Date: Mon, 11 Nov 2013 16:51:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: "Test object code reading" failing, debug messages don't help
Message-ID: <20131111195117.GI27198@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

	I have perf test failing here:

[root@ssdandy ~]# perf test 21
21: Test object code reading                               : FAILED!
[root@ssdandy ~]# 

Try it with -v, but all messages, except for that elf header, which I
assume is for a previous entry that is not suitable and should not be
considered, seems to say all is well, except that the test fails :-\

[root@ssdandy ~]# perf test -v 21
21: Test object code reading                               :
--- start ---
Looking at the vmlinux_path (6 entries long)
symsrc__init: cannot get elf header.
Using /lib/modules/3.12.0-rc6+/build/vmlinux for symbols
Parsing event 'cycles'
mmap size 528384B
Reading object code for memory address: 0xffffffff8101d2ad
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x21d2ad
Objdump command is: objdump -d --start-address=0xffffffff8101d2ad --stop-address=0xffffffff8101d32d /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
Reading object code for memory address: 0xffffffff8101d2ad
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x21d2ad
Objdump command is: objdump -d --start-address=0xffffffff8101d2ad --stop-address=0xffffffff8101d32d /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
Reading object code for memory address: 0xffffffff8101d2ad
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x21d2ad
Objdump command is: objdump -d --start-address=0xffffffff8101d2ad --stop-address=0xffffffff8101d32d /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
Reading object code for memory address: 0xffffffff8101d2ad
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x21d2ad
Objdump command is: objdump -d --start-address=0xffffffff8101d2ad --stop-address=0xffffffff8101d32d /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
Reading object code for memory address: 0xffffffff8101d2ad
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x21d2ad
Objdump command is: objdump -d --start-address=0xffffffff8101d2ad --stop-address=0xffffffff8101d32d /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
Reading object code for memory address: 0xffffffff81124ae5
File is: /lib/modules/3.12.0-rc6+/build/vmlinux
On file address is: 0x324ae5
Objdump command is: objdump -d --start-address=0xffffffff81124ae5 --stop-address=0xffffffff81124b65 /lib/modules/3.12.0-rc6+/build/vmlinux
Bytes read match those read by objdump
---- end ----
Test object code reading: FAILED!
[root@ssdandy ~]#

Can you try this on acme/perf/core? And improve the debug messages, if
possible?

- Arnaldo
