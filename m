Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3DZJjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:39:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3DZJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:39:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        magnus.p.persson@stericsson.com,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
Date: Fri, 26 Apr 2013 11:39:20 +0200
Message-ID: <1457204.tIrKjcEogd@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130426081646.GD24632@intel.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com> <20130426081646.GD24632@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Qm2tPfHSYNdMGCnkYEqWj/iWWl286XjRBqEhFeh30Rl
 rBtYKuuSwPl5l1GIqiidgoy0/+HIt+0VFPfurmHe7jnGk1Gc7a
 2WtOHjsnybwXSZtF5BLuwQcNBh4pNKDuxzx3mjZ/47pNKkAFq2
 Q15MEc6JoxWSp1HYeF/9gfUSKY4y44oA/2mb4VaGQKFNIpTQp7
 RTio6oeNeCDU6XAphlrXayMCqElfp2YkBw5Bx61URaByp1AKRA
 C2eAhwmgvvcC7AKTymHmzHpAM7cxqwj+ZTaGq7wnpIabE0J1vM
 AFzrquuCjZyigts/GqTscNzhaTgH+eWpLEwtd5S1br+GSC6ZKt
 /Wh+HbSsGB2+s6KXwt0k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013 13:46:46 Vinod Koul wrote:
> 
> The mapping & unmapping of dma buffer (memcpy and memory buffer in this txn) is
> required to be performed by the client driver. The dmanegine or dmaengine driver
> will not do that for you...

I've been wondering about this part: since we need to pass the 'struct device' of
the dma engine (rather than the slave) into dma_map_single, what is the official
way to do that? Should the slave driver just rely on dma_chan->device->dev to
work correctly for the purpose of dma-mapping.h interfaces?

	Arnd
