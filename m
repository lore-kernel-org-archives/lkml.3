Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaIYLFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:05:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51704 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbaIYLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:05:14 -0400
X-Sasl-enc: YMSFt8aZgMKCdA7cKuuUA7PsbnY5lHHHPIAxpIqsrULb 1411643113
Date: Thu, 25 Sep 2014 13:04:19 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20140925110419.GA31383@kroah.com>
References: <20140925163036.5f3281eb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925163036.5f3281eb@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 04:30:36PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (arm multi_v7_defconfig)
> failed like this:
> 
> In file included from init/do_mounts.c:15:0:
> include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
>          unused:62;
>          ^
> include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
>          unused_ctrl:55;
>          ^
> In file included from init/main.c:28:0:
> include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
>          unused:62;
>          ^
> include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
>          unused_ctrl:55;
>          ^
> In file included from include/linux/serial_core.h:29:0,
>                  from include/linux/serial_s3c.h:236,
>                  from arch/arm/mach-exynos/exynos.c:15:
> include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
>          unused:62;
>          ^
> include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
>          unused_ctrl:55;
>          ^
> In file included from include/linux/serial_core.h:29:0,
>                  from include/linux/platform_data/serial-omap.h:20,
>                  from arch/arm/mach-omap2/serial.c:30:
> include/linux/tty.h:267:9: error: width of 'unused' exceeds its type
>          unused:62;
>          ^
> include/linux/tty.h:271:9: error: width of 'unused_ctrl' exceeds its type
>          unused_ctrl:55;
>          ^
> 
> Caused by commits c545b66c6922 ("tty: Serialize tcflow() with other tty
> flow control changes") and 99416322dd16 ("tty: Workaround Alpha
> non-atomic byte storage in tty_struct").  There are still 32 bit
> architectures out there!  ;-)

Sorry about that, a fix for this is now in my tree.

greg k-h
