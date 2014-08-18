Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaHRIkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:40:00 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36880 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaHRIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:39:58 -0400
Date: Mon, 18 Aug 2014 09:39:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140818083953.GA4266@lee--X1>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
 <20140814224013.GE18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140814224013.GE18411@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014, Brian Norris wrote:
> On Wed, Aug 13, 2014 at 10:11:59AM +0100, Lee Jones wrote:
> > Hi Brian, Pekon,
> > 
> > I believe all of your queries have either been answered or addressed
> > and I am hoping this will be the last submission. :)
> > 
> > /me crosses fingers!
> > 
> > Kind regards,
> > Lee
> 
> I didn't look through the patches yet, but my build tools tell me you
> didn't compile-test this. Please compile, test, and resend your patches.
> 
> In file included from drivers/mtd/nand/stm_nand_bch.c:26:0:
> include/linux/mtd/stm_nand_bbt.h:16:13: warning: no previous prototype for 'nandi_dump_bad_blocks' [-Wmissing-prototypes]
> drivers/mtd/nand/stm_nand_bch.c: In function 'nandi_set_mtd_defaults':
> drivers/mtd/nand/stm_nand_bch.c:870:19: error: 'bch_scan_bbt' undeclared (first use in this function)
> drivers/mtd/nand/stm_nand_bch.c:870:19: note: each undeclared identifier is reported only once for each function it appears in
> drivers/mtd/nand/stm_nand_bch.c:871:20: error: 'bch_block_isbad' undeclared (first use in this function)
> drivers/mtd/nand/stm_nand_bch.c:872:24: error: 'bch_block_markbad'
> undeclared (first use in this function)

These are due to a CONFIG rename I did lastminute.com.  I fixed it
~2mins after sending the set and will re-send today.

> Particularly, take a hard look at rewriting
> include/linux/mtd/stm_nand_bbt.h.

I don't think there is any need - although this change is required:

-#if defined(MTD_NAND_STM_BBT)
+#if defined(MTD_NAND_STM_BCH_BBT)

> drivers/mtd/nand/stm_nand_bch.c: In function 'bch_calc_timing_registers':
> drivers/mtd/nand/stm_nand_bch.c:1022:6: warning: variable 'ren_half_off' set but not used [-Wunused-but-set-variable]
> drivers/mtd/nand/stm_nand_bch.c:1021:6: warning: variable 'ren_half_on' set but not used [-Wunused-but-set-variable]

This I have never seen.  I guess -Wunused-but-set-variable is normally
off.  This issue has been present since the beginning of this endeavour
and exists in the original (internal) code.

Will fix.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
