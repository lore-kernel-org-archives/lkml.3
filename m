Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaLYJL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:11:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaLYJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:11:24 -0500
Date: Thu, 25 Dec 2014 10:11:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        sre@debian.org, sre@ring0.de, aaro.koskinen@iki.fi, tony@atomide.com,
        ivo.g.dimitrov.75@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: v3.19-rc1 regression(?) on N900
Message-ID: <20141225091121.GA20355@amd>
References: <549B44E2.6080202@ti.com>
 <201412250932.40403@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412250932.40403@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-12-25 09:32:40, Pali Rohár wrote:
> On Wednesday 24 December 2014 23:57:38 Nishanth Menon wrote:
> > based on automated testing with u-boot as a chained
> > bootloader..
> > 
> > v3.18: boots fine:
> > https://github.com/nmenon/kernel-test-logs/blob/v3.18/omap2plu
> > s_defconfig/n900.txt
> > 
> > v3.19-rc1: hung
> > https://github.com/nmenon/kernel-test-logs/blob/v3.19-rc1/omap
> > 2plus_defconfig/n900.txt
> > 
> > in the interim, my farm had a bit of breakdown around the time
> > of n900 breakdown..
> > 
> > as per my last functional linux-next logs:
> > https://github.com/nmenon/kernel-test-logs/blob/next-20141204/
> > omap2plus_defconfig/n900.txt -> hung.
> > https://github.com/nmenon/kernel-test-logs/blob/next-20141112/
> > omap2plus_defconfig/n900.txt -> working.
> > 
> > DEBUG_LL, CONFIG_DEBUG_OMAP3UART3=y and early_printk did not
> > yield information either

Early hang, independend on config. That's "dtb too big". Delete
something, and it should work again.

Plus you'll note video regression.

# > I test-merged 3315764efceaccfb02c7d4c99ef8eed6716cd861, and boom,
# > video is gone.
#
# I reverted
#
# > 4b4123f0c7b02f7cf1a3189f967f079197578c3a..9051909e451a0368c95ccf74562adb53fd2719f8
# in 3.19, and voila, video is back.

> CCing other people.
> 
> I see same problem in qemu with 3.19-rc1 kernel when doing DT 
> boot. In qemu I'm using direct booting from OneNAND (X-Loader --> 
> NOLO --> kernel) without U-Boot. After NOLO load & boot kernel I 
> do not see any other output from serial console. Also on qemu 
> screen there is no new output (just NOKIA logo from bootloader).
> 
> I do not have this problem when doing legacy/board code boot with 
> 3.19-rc1 kernel, so this problem is related to DT.
> 
> Kernel 3.18-rc1 worked fine for both DT and legacy boot.
> 
> Can somebody look what broke DT booting?

It was too big dtb, at least for me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
