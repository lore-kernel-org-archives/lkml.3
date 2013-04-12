Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3DLT2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:28:24 -0400
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1075 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3DLT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:28:23 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3362
Message-ID: <5168601F.2070409@metafoo.de>
Date: Fri, 12 Apr 2013 21:27:27 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 20/30] ASoC: samsung: convert to dmaengine
 API
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-21-git-send-email-arnd@arndb.de> <20130411142706.GB24971@opensource.wolfsonmicro.com> <201304111647.17796.arnd@arndb.de>
In-Reply-To: <201304111647.17796.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 04:47 PM, Arnd Bergmann wrote:
> On Thursday 11 April 2013, Mark Brown wrote:
>>
>> On Thu, Apr 11, 2013 at 02:05:02AM +0200, Arnd Bergmann wrote:
>>> In order to build the exynos kernel with CONFIG_ARCH_MULTIPLATFORM,
>>> we must convert all users of the Samsung private DMA interface to
>>> the generic dmaengine API. This version of the patch adds the
>>> generic dmaengine API as an alternative to the existing samsung
>>> specific one. Once all the older platforms provide support for
>>> the common dmaengine interfaces, we can remove the old code.
>>
>> There's generic ASoC dmaengine code which should be used instead of open
>> coding this.  Lars-Peter Clausen and Lee Jones have been working on
>> making this a totally generic driver, right now it's a library.
> 
> Ok, I see. I'll drop this patch from my series then and will let someone
> else handle this driver in 3.11. We can probably live without sound support
> in 3.10 when running a multiplatform kernel, and it will keep working
> for exynos-only kernels without the patch.

I actually had a look at how the Samsung PCM driver a couple of days back,
but I didn't fully grasp how things work with the secondary TX channel for
the i2s driver and to make it work with the generic dmaengine PCM driver.
The code handling this in the i2s driver seems to be rather messy with lots
of ifs and elses. Also things would have would be a lot easier if the dt
bindings had used two subnodes each with their own 'dmas' property.

- Lars

