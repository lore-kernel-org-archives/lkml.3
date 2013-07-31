Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab3GaNsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:48:08 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58897 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab3GaNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:48:03 -0400
Date: Wed, 31 Jul 2013 22:47:50 +0900
From: Minchan Kim <minchan@kernel.org>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: gregkh@linuxfoundation.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        b.zolnierkie@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] staging: zram: add Crypto API support
Message-ID: <20130731134750.GA4523@gmail.com>
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 02:30:48PM +0200, Piotr Sarna wrote:
> Current version of zram does not allow any substitution of a default
> compression algorithm. Therefore, I decided to change the existing
> implementation of page compression by adding Crypto API compability.
> 
> All direct calls to lzo1x compression/decompression methods are now
> replaced by calls consistent with Crypto. Also, I removed "workmem"
> field from struct zram_meta, as it was there for lzo1x purposes only
> and is no longer needed. Finally, I added a set of functions required
> by Crypto API to work properly.
> 
> In order to substitute the default algorithm (lzo), change the value
> of zram.compressor module parameter to a proper name (e.g. lz4).

Your patch [1,2/2] are totally same patch I made for using in-house only.
Why I made it for in-house only is that Greg doesn't want to merge any
new features before zram promotion is done.
I understand him totally because I will do same thing as if I were
maintainer.

I tried zram promotion several long time ago but unfortunately, failed.
Sine then, I have been busy by other stuffs.

http://comments.gmane.org/gmane.linux.kernel.mm/90264

The reason to prevent zram promotion is only zsmalloc while Jens
already acked zram part because zsmalloc was used for zcache,
zram and zswap at that time and they have different requirements
for zsmalloc. But recently, zsmalloc is used for only zram so I guess
we could put zsmalloc with zram in driver/block. Of course, we should
discuss it with akpm.

Okay. I think it's good time to promote zram again and I will retry
soon.

Thanks.

> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

-- 
Kind regards,
Minchan Kim
