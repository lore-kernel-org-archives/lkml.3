Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaLAIrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:47:14 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53753 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:47:13 -0500
Date: Mon, 1 Dec 2014 00:47:09 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v6 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141201084709.GI29070@brian-ubuntu>
References: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 07:10:27PM +0100, Boris Brezillon wrote:
> Hello,
> 
> This series provides an implementation for raw accesses taking care of
> hidding the specific layout used by the GPMI controller.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v5:
>  - rename gpmi_move_bits into gpmi_copy_bits
> 
> Changes since v4:
>  - fixed a few corner cases in gpmi_move_bits (tested it with:
>    https://github.com/bbrezillon/gpmi-move-bits-test/blob/master/gpmi-move-bits-test.c)
>  - add documentation and comments for the new gpmi functions
> 
> Changes since v3:
>  - add comments to the gpmi_move_bits function
>  - extend raw read/write documentation
>  - move last part of the raw_page_read function into a conditional block
> 
> Changes since v2:
>  - fixed a bug in gpmi_move_bits
>  - add a raw_buffer field to be used when using raw access methods
>    (experienced memory corruptions when directly using page_buffer_virt
>    buffer)
>  - add raw OOB access functions

Applied the series. Thanks!

Out of curiosity, what tests does gpmi-nand.c now pass/fail?

Also, is it time to yank / fixup some of these comments from
gpmi-nand.c?

 ...
 * FIXME: The following paragraph is incorrect, now that there exist
 * ecc.read_oob_raw and ecc.write_oob_raw functions.
 *
 * Since MTD assumes the OOB is not covered by ECC, there is no pair of
 * ECC-based/raw functions for reading or or writing the OOB. The fact that the
 * caller wants an ECC-based or raw view of the page is not propagated down to
 * this driver.
 */

Brian
