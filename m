Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbaISTmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:42:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61269 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbaISTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:42:50 -0400
Date: Fri, 19 Sep 2014 12:42:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919194245.GA14491@roeck-us.net>
References: <20140919165817.225eb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919165817.225eb8b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140917:
> 
> The fsl tree still had its build failure so I used the version from
> next-20140917.
> 
> The v4l-dvb tree lost its build failure.
> 
> The security tree gained a conflict against the file-locks tree.
> 
> Non-merge commits (relative to Linus' tree): 6014
>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
sparc64:allmodconfig:

In file included from drivers/tty/serial/serial_mctrl_gpio.c:21:0:
include/uapi/asm-generic/termios.h:22:8: error: redefinition of 'struct termio'
./arch/sparc/include/uapi/asm/termbits.h:16:8: note: originally defined here
make[3]: *** [drivers/tty/serial/serial_mctrl_gpio.o] Error 1

Caused by commit 62b0a1b3e759 ('serial: clps711x: Use mctrl_gpio helpers for
handling modem signals'), which enables SERIAL_MCTRL_GPIO for this build,
but SERIAL_MCTRL_GPIO doesn't work for sparc64.

bisect log:

# bad: [6a10bca9b608df445baa23c3bfafc510d93d425b] Add linux-next specific files for 20140919
# good: [9e82bf014195d6f0054982c463575cdce24292be] Linux 3.17-rc5
git bisect start 'HEAD' 'v3.17-rc5'
# good: [fde058e2322b9098251d7cf798cac4327a29c004] Merge remote-tracking branch 'drm/drm-next'
git bisect good fde058e2322b9098251d7cf798cac4327a29c004
# bad: [8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb] Merge remote-tracking branch 'usb-serial/usb-next'
git bisect bad 8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb
# good: [5a571cebb73888024182de09063db35341e61beb] Merge remote-tracking branch 'spi/for-next'
git bisect good 5a571cebb73888024182de09063db35341e61beb
# good: [249a58bd0f355bc12549d00296684103326ac38f] Merge remote-tracking branch 'rcu/rcu/next'
git bisect good 249a58bd0f355bc12549d00296684103326ac38f
# good: [2154c4598a10e4dfeaf8061cd7b7511c3d4cf32b] Merge remote-tracking branch 'regmap/for-next'
git bisect good 2154c4598a10e4dfeaf8061cd7b7511c3d4cf32b
# good: [72a65a0d19c16de36e970ca6981732b5e8f7f4c4] Revert "usb: gadget: composite: dequeue cdev->req before free its buffer"
git bisect good 72a65a0d19c16de36e970ca6981732b5e8f7f4c4
# bad: [ae14a7954f5124208e6e93cafb3099f83acd43f5] tty: serial: 8250_core: provide a function to export uart_8250_port
git bisect bad ae14a7954f5124208e6e93cafb3099f83acd43f5
# bad: [920314dfd05f40cbe8ad677ba733ff1f8814d93a] serial: Fix build failure caused by missing header file
git bisect bad 920314dfd05f40cbe8ad677ba733ff1f8814d93a
# good: [2f2dafe77df2c78e189a9fa6b1879dffd06ae5a1] serial: serial_core.c: printk replacement
git bisect good 2f2dafe77df2c78e189a9fa6b1879dffd06ae5a1
# bad: [c10b73905a0bb4b91e6c153dbbf4c2809084e4c2] serial: 8250_hp300: trivial: fix symbol name in #warning message
git bisect bad c10b73905a0bb4b91e6c153dbbf4c2809084e4c2
# bad: [8b374399468da1c25db5b5d436b167aafc10fbdc] serial: msm_serial: Fix kgdb continue
git bisect bad 8b374399468da1c25db5b5d436b167aafc10fbdc
# bad: [e0525393baf07b1bb6e537ddbe7dfae3621649df] TTY: fix decimal printf format specifiers prefixed with 0x
git bisect bad e0525393baf07b1bb6e537ddbe7dfae3621649df
# bad: [62b0a1b3e7593e0647db9ecc5e7809e4410acb81] serial: clps711x: Use mctrl_gpio helpers for handling modem signals
git bisect bad 62b0a1b3e7593e0647db9ecc5e7809e4410acb81
# first bad commit: [62b0a1b3e7593e0647db9ecc5e7809e4410acb81] serial: clps711x: Use mctrl_gpio helpers for handling modem signals
