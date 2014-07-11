Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaGKN4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:56:23 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59836 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaGKN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:56:19 -0400
Date: Fri, 11 Jul 2014 14:56:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: No uart output on my snowball board
Message-ID: <20140711135613.GC2954@lee--X1>
References: <20140710223021.6e9c857f@gandalf.local.home>
 <CACRpkdZM5NECaPbFC1aGH2zD4T_8g9TYRy1HkbDVAQvjJs5E5w@mail.gmail.com>
 <20140711093108.4807d473@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140711093108.4807d473@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Steven Rostedt wrote:

> On Fri, 11 Jul 2014 14:00:55 +0200
> Linus Walleij <linus.walleij@linaro.org> wrote:
> 
> > On Fri, Jul 11, 2014 at 4:30 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > commit a0998b8321eb5f53ef51924f5ab6c69237ac1025
> > > Author: Lee Jones <lee.jones@linaro.org>
> > > Date:   Thu Aug 22 16:18:56 2013 +0100
> > >
> > >     ARM: ux500: Remove UART support when booting without Device Tree
> > >
> > >     It's time to remove all ATAG support from ux500 and rely solely on
> > >     Device Tree booting. This patch is part of that endeavour.
> > >
> > >     Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > >     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > 
> > I hate that I didn't spot the speling mistake in the subject,
> > its ATAG support we're removing, not UART :-)
> > 
> > Anyway, I think you got enough hints on how we do this
> > with appended devicetrees instead, Lee's snippet should
> > work or check out this page that I also posted to your
> > G+ post:
> > http://www.df.lth.se/~triad/krad/ux00/
> > 
> 
> Thanks, with everyone's feedback I got it working with ktest.
> 
> I added the following to my ktest snowball.conf:
> 
> OUTPUT_BOOT := ${OUTPUT_DIR}/arch/arm/boot
> 
> PRE_BUILD = ${MAKE_CMD} O=${OUTPUT_DIR} dtbs
> POST_BUILD = cat ${OUTPUT_BOOT}/zImage ${OUTPUT_BOOT}/dts/ste-snowball.dtb > ${OUTPUT_BOOT}/zImage.snowball; mkimage -A arm -O linux -C none -T kernel -a 0x00008000 -e 0x00008000 -d ${OUTPUT_BOOT}/zImage.snowball ${OUTPUT_BOOT}/uImage.snowball
> 
> and walla!
> 
> root@linaro-ubuntu-desktop:~# uname -r
> 3.16.0-rc4-test-00042-g4f440cd

Good work.  Glad to be of service.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
