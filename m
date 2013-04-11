Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936296Ab3DKOrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:47:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab3DKOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:47:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 20/30] ASoC: samsung: convert to dmaengine API
Date: Thu, 11 Apr 2013 16:47:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-21-git-send-email-arnd@arndb.de> <20130411142706.GB24971@opensource.wolfsonmicro.com>
In-Reply-To: <20130411142706.GB24971@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111647.17796.arnd@arndb.de>
X-Provags-ID: V02:K0:3Q98620fw6mV18mNmj4RC/tEA5IW6sOfIYuvuye3vQD
 NZ2t0O8bcL8ojCrvZVg8k5y11ktkkH0JUch8LefUheddOwbIPA
 K3IKy+KD4Ouj9A+RRS08bmZ0Mqwf4itsQ0kEzXBGUThKgrsA5z
 Lp/bQpTmzJuGAKoI+5hneBGfh4ObmhUZuxmcOKa+KkwZfG7Q/3
 jWye+JnFLeQ8QXkuGfus7YBuHGXniJOx3dLS6MRN25gE30+AWd
 /Yymu3tx4L013QD+RqQiUq9YRlJ+OaaK8n0K9EEyGHccKmUY22
 Oow/P7PB8Xbw3+GtpyL+6p0wfd/BQl3JXDRFfz0gH70Z10WJ5n
 Yeonv80tzYIY+GnGaZXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Mark Brown wrote:
> 
> On Thu, Apr 11, 2013 at 02:05:02AM +0200, Arnd Bergmann wrote:
> > In order to build the exynos kernel with CONFIG_ARCH_MULTIPLATFORM,
> > we must convert all users of the Samsung private DMA interface to
> > the generic dmaengine API. This version of the patch adds the
> > generic dmaengine API as an alternative to the existing samsung
> > specific one. Once all the older platforms provide support for
> > the common dmaengine interfaces, we can remove the old code.
> 
> There's generic ASoC dmaengine code which should be used instead of open
> coding this.  Lars-Peter Clausen and Lee Jones have been working on
> making this a totally generic driver, right now it's a library.

Ok, I see. I'll drop this patch from my series then and will let someone
else handle this driver in 3.11. We can probably live without sound support
in 3.10 when running a multiplatform kernel, and it will keep working
for exynos-only kernels without the patch.

Can you have a look at the other three ASoC patches in the series? I think
it would still be useful to merge them.

	Arnd
