Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaGKNbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:31:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:35390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753725AbaGKNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:31:18 -0400
Date: Fri, 11 Jul 2014 09:31:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: No uart output on my snowball board
Message-ID: <20140711093108.4807d473@gandalf.local.home>
In-Reply-To: <CACRpkdZM5NECaPbFC1aGH2zD4T_8g9TYRy1HkbDVAQvjJs5E5w@mail.gmail.com>
References: <20140710223021.6e9c857f@gandalf.local.home>
	<CACRpkdZM5NECaPbFC1aGH2zD4T_8g9TYRy1HkbDVAQvjJs5E5w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 14:00:55 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Fri, Jul 11, 2014 at 4:30 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > commit a0998b8321eb5f53ef51924f5ab6c69237ac1025
> > Author: Lee Jones <lee.jones@linaro.org>
> > Date:   Thu Aug 22 16:18:56 2013 +0100
> >
> >     ARM: ux500: Remove UART support when booting without Device Tree
> >
> >     It's time to remove all ATAG support from ux500 and rely solely on
> >     Device Tree booting. This patch is part of that endeavour.
> >
> >     Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I hate that I didn't spot the speling mistake in the subject,
> its ATAG support we're removing, not UART :-)
> 
> Anyway, I think you got enough hints on how we do this
> with appended devicetrees instead, Lee's snippet should
> work or check out this page that I also posted to your
> G+ post:
> http://www.df.lth.se/~triad/krad/ux00/
> 

Thanks, with everyone's feedback I got it working with ktest.

I added the following to my ktest snowball.conf:

OUTPUT_BOOT := ${OUTPUT_DIR}/arch/arm/boot

PRE_BUILD = ${MAKE_CMD} O=${OUTPUT_DIR} dtbs
POST_BUILD = cat ${OUTPUT_BOOT}/zImage ${OUTPUT_BOOT}/dts/ste-snowball.dtb > ${OUTPUT_BOOT}/zImage.snowball; mkimage -A arm -O linux -C none -T kernel -a 0x00008000 -e 0x00008000 -d ${OUTPUT_BOOT}/zImage.snowball ${OUTPUT_BOOT}/uImage.snowball

and walla!

root@linaro-ubuntu-desktop:~# uname -r
3.16.0-rc4-test-00042-g4f440cd


Thanks everyone!

-- Steve
