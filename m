Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3HTQhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:37:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36733 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3HTQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:37:36 -0400
Message-ID: <52139B4E.6070700@wwwdotorg.org>
Date: Tue, 20 Aug 2013 10:37:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: fix SPI_BIT_MASK() to use correct size for 32-bit
 transfer mask
References: <1377000932-5438-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1377000932-5438-1-git-send-email-mika.westerberg@linux.intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 06:15 AM, Mika Westerberg wrote:
> When building a 64-bit kernel we get the following warning from the
> compiler:
> 
>  drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
>  drivers/spi/spi-pxa2xx.c:1152:3: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>    master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
>    ^
> This is due the fact that when the max range is specified as 32
> SPI_BIT_MASK() expands to ~0UL which doesn't fit to the u32 type that the
> master->bits_per_word_mask is.
> 
> Fix this by using ~0U instead.

The same patch is already in next-20130819 at least, as:
b6aa23c spi: fix SPI_BIT_MASK so it always fits into 32-bits
