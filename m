Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbaISTEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:04:43 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56569 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:04:41 -0400
Date: Fri, 19 Sep 2014 12:04:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        linux-serial@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919190436.GA24045@roeck-us.net>
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

m68k-allyesconfig, m68k:allmodconfig:

drivers/tty/serial/st-asc.c: In function 'asc_in':
drivers/tty/serial/st-asc.c:154:2: error:
		implicit declaration of function 'readl_relaxed' [-Werror=implicit-function-declaration]

Caused by commit 08177ece596c ('serial: asc: Adopt readl_/writel_relaxed()').

Bisect result:

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
# good: [ae14a7954f5124208e6e93cafb3099f83acd43f5] tty: serial: 8250_core: provide a function to export uart_8250_port
git bisect good ae14a7954f5124208e6e93cafb3099f83acd43f5
# bad: [424f7d585835549d8875825c7cea9e73506eff8c] Merge remote-tracking branch 'tty/tty-next'
git bisect bad 424f7d585835549d8875825c7cea9e73506eff8c
# good: [f20431c51f565a7a3edd9b139742d7a71f3111b3] Merge remote-tracking branch 'ipmi/for-next'
git bisect good f20431c51f565a7a3edd9b139742d7a71f3111b3
# good: [999156ada570cb4a2eaee42e47c9e659b5c577fb] sparc/uapi: Add definition of TIOC[SG]RS485
git bisect good 999156ada570cb4a2eaee42e47c9e659b5c577fb
# bad: [b4756f4f0d773c31e59f203e7f19fd3d5c490193] tty: serial: 8250: Add Mediatek UART driver
git bisect bad b4756f4f0d773c31e59f203e7f19fd3d5c490193
# bad: [08177ece596ccc9b9c194542c095c863c101fd11] serial: asc: Adopt readl_/writel_relaxed()
git bisect bad 08177ece596ccc9b9c194542c095c863c101fd11
# good: [efb089517d2f34a58aceb600ab58b0ca3db1fa07] serial: clps711x: Fix COMPILE_TEST build for target without GPIOLIB support
git bisect good efb089517d2f34a58aceb600ab58b0ca3db1fa07
# first bad commit: [08177ece596ccc9b9c194542c095c863c101fd11] serial: asc: Adopt readl_/writel_relaxed()
