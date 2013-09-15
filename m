Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3IOSgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 14:36:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3IOSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 14:36:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH 1/2] ARM: msm: trout: fix 'pointer from integer' warnings
Date: Sun, 15 Sep 2013 20:36:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <5350fa5571d24b68d6bb27959d3ef761ccb95b00.1378771874.git.joshc@codeaurora.org>
In-Reply-To: <5350fa5571d24b68d6bb27959d3ef761ccb95b00.1378771874.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201309152036.18373.arnd@arndb.de>
X-Provags-ID: V02:K0:0EeEnZKqCwAHuQzk1YoaxeyZvHpGBP79+IIPUFRGQeA
 udw6ka7oyQDIub+AV7jJ+qHMvefFqJf6b5UlhKCq0qiO3+coyD
 37+mDM3s2nzAp/kxm7sYI8js0wA9w3671ZltyW5hsnU1p3PwKW
 mjV09VjBbbJWmS/0+CqtSVXN5rpWW0rCH2UPeoq1IWp2aAKQf5
 hi3Kv5yZQuaK3ylut8QQ/rrSoEYHuEmx4sAkJAY6Q4oQYFQVnE
 QrnNNOo1TabrZUYq1z8ywc1bU6bHL4cwcigIsRUYSgNgsU465j
 Y9UbvGUyFqeB9dhef3VtY8z+eO/Lo2XqQQLWAZNR2X2CCk3g+o
 WY8zCdeNzlaJ6UWqSzCc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 September 2013, Josh Cartwright wrote:
> -#define TROUT_GPIO_INT_MASK0_REG            (0x0c)
> -#define TROUT_GPIO_INT_STAT0_REG            (0x0e)
> -#define TROUT_GPIO_INT_MASK1_REG            (0x14)
> -#define TROUT_GPIO_INT_STAT1_REG            (0x10)
> +#define TROUT_GPIO_INT_MASK0_REG            IOMEM(0x0c)
> +#define TROUT_GPIO_INT_STAT0_REG            IOMEM(0x0e)
> +#define TROUT_GPIO_INT_MASK1_REG            IOMEM(0x14)
> +#define TROUT_GPIO_INT_STAT1_REG            IOMEM(0x10)

This is wrong, the values above are offsets from TROUT_CPLD_BASE. Instead you
need to make that constant an __iomem token and leave these as integers.

	Arnd
