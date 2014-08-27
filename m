Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935467AbaH0Rdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:33:49 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46560 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbaH0Rdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140827105838.GA6522@sudip-PC>
References: <CA+r1Zhh5n3p8Zg+Uvqvjeb3S859iejXkqStnnOuezTTm9UCT8g@mail.gmail.com>
	<20140827105838.GA6522@sudip-PC>
Date: Wed, 27 Aug 2014 10:33:46 -0700
Message-ID: <CA+r1Zhh10fMu4yvFwz__5wt1X3hUZeOpy5yviXy7NY_w+Ugb6w@mail.gmail.com>
Subject: Re: randconfig build error with next-20140826, in Documentation/video4linux
From: Jim Davis <jim.epost@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:58 AM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:

> Hi,
> I tried to build next-20140826 with your given config file . But for me everything was fine.

Well, you should be able to reproduce it.  Do these steps work for you?

jim@krebstar:~/linux2$ git checkout next-20140826
HEAD is now at 1c9e4561f3b2... Add linux-next specific files for 20140826
jim@krebstar:~/linux2$ git clean -fdx
jim@krebstar:~/linux2$ cp ~/randconfig-1409069188.txt .config
jim@krebstar:~/linux2$ make oldconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#
jim@krebstar:~/linux2$ make -j4 >buildlog.txt 2>&1
jim@krebstar:~/linux2$ grep ERROR buildlog.txt
ERROR: "vb2_ops_wait_finish"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!

(followed by many more similar lines).
