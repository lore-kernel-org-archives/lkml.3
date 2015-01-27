Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbbA0Jov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:44:51 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:1137 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbbA0Jos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:44:48 -0500
Message-ID: <54C75E09.6050002@free.fr>
Date: Tue, 27 Jan 2015 10:44:41 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0 SeaMonkey/2.32
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Embedded white space in out-of-tree module full pathname
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like some confirmation that this is either not supported, or that
I'm doing something obviously wrong. (Kernel 3.14 if it matters.)

Suppose the source code for an out-of-tree kernel module is stored e.g.
in "/tmp/foo bar/module" (note the embedded space in the path name)

Here is the Makefile template I'm using. (Maybe it's wrong.)

/tmp/foo bar/module$ cat Makefile
KDIR          ?= /home/mason/linux-3.14
ARCH          ?= arm
CROSS_COMPILE ?= arm-none-linux-gnueabi-

obj-m += mytest.o

all:
	make -C $(KDIR) M="$$PWD"

clean:
	make -C $(KDIR) M="$$PWD" clean

/tmp/foo bar/module$ make
make -C /home/mason/linux-3.14 M="$PWD"
make[1]: Entering directory `/home/mason/linux-3.14'
scripts/Makefile.build:44: /tmp/foo/Makefile: No such file or directory
make[2]: *** No rule to make target `/tmp/foo/Makefile'.  Stop.
make[1]: *** [_module_/tmp/foo] Error 2
make[1]: Leaving directory `/home/mason/linux-3.14'
make: *** [all] Error 2


Does the kernel build system support building an out-of-tree module whose
full pathname contains embedded white space, like in my example?

Do I have an obvious mistake in my Makefile?

Regards.
