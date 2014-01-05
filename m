Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaAESwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:52:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAESwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:52:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Meier <florian.meier@koalo.de>
Subject: Re: [PATCHv9] dmaengine: Add support for BCM2835
Date: Sun, 5 Jan 2014 19:52:07 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-rpi-kernel" <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
References: <52C5A6A3.8000405@koalo.de> <201401051506.03481.arnd@arndb.de> <CABDT8WyUVbPu60qwMbAxKS=2m2akskybZQS3-+rehuUD+3oBXQ@mail.gmail.com>
In-Reply-To: <CABDT8WyUVbPu60qwMbAxKS=2m2akskybZQS3-+rehuUD+3oBXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401051952.07355.arnd@arndb.de>
X-Provags-ID: V02:K0:LJGVFfyHQjP2yTVHwnnrud09LZYUv+UyqIkgKLKXkuf
 kEEhR+s+Ifn9pN7XekHE51e5WZaYYFafeZrgm/rLvPPBXRzICT
 Ae82b2UappNdCrju8W7gJElteE+GIjfzokWkRoBAosB4ywqpmV
 jyPZ8HSIhOCGhQpvVnObLRc1G4QsIG47r4XoWBi8cczBjh1xUu
 Lokt8SwwzPtXJ5VExBasF/ZgpbdX3njQq3QI5DxrR/uYpnnccp
 MRSuswUWztrkAx0S1liXIJ8MLJ5JYXi1bxqbqfExBmTINob/mn
 IEwYI4bp4WkedASMUej6WZ6DJEVjiGo/DXbSFR8xx3w/E+73R8
 3M0q2G5HOj/YoIsUdKF0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 January 2014, Florian Meier wrote:
> On 05.01.2014 15:06, Arnd Bergmann wrote:
> >>
> >> Sigh, the API is developing faster than I can keep track with updating
> >> this patch. I hope some day I will be faster....
> >> When Russell told me about the second one before, it hoped that I can
> >> avoid merging different trees on my own, but it seems that you want me
> >> to do that ;-)
> >
> > The dma_get_any_slave_channel() change is probably my fault. I suggested
> > both the initial dma_get_slave_channel() API and this one because the
> > original approach turned out too complicated. If dma_set_mask_and_coherent().
> >
> > I don't think you have to merge other trees, to get both APIs, they should
> > already be part of the dma-slave tree that your patch would get merged
> > into. If not, we can probably come up with a different solution. The
> > dma_set_mask_and_coherent() suggestion is not as important as the
> > dma_get_any_slave_channel() one, if you have to choose between them.
> 
> Both changes are in the slave-dma tree, but I need patches from the
> bcm2835 tree and the asoc tree, too. Although, it shouldn't be too
> complicated to merge them, I hope.

Why do you need the bcm2835 and asoc changes? The addition of the
dmaengine driver should be self-contained as far as I can tell,
except that the audio driver won't work unless both are merged.

This wouldn't be considered a strict dependency since you are not
breaking anything that used to work prior to the patches, and you
don't create a kernel version that doesn't build. Note that this
would be different if you had a dependency on a platform_data
definition.

	Arnd
