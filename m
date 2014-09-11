Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaIKMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:09:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35527 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaIKMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:09:48 -0400
Date: Thu, 11 Sep 2014 20:09:30 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140911120928.GA1585@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> Several MTD users (either in user or kernel space) expect a valid raw
> access support to NAND chip devices.
> This is particularly true for testing tools which are often touching the
> data stored in a NAND chip in raw mode to artificially generate errors.
> 
> The GPMI drivers do not implemenent raw access functions, and thus rely on
> default HW_ECC scheme implementation.
> The default implementation consider the data and OOB area as properly
> separated in their respective NAND section, which is not true for the GPMI
> controller.
> In this driver/controller some OOB data are stored at the beginning of the
> NAND data area (these data are called metadata in the driver), then ECC
> bytes are interleaved with data chunk (which is similar to the
> HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> OOB data.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
> Hello,
> 
> This patch is providing raw access support to the GPMI driver which is
> particularly useful to run some tests on the NAND (the one coming in
> mind is the mtd_nandbiterrs testsuite).
> 
> I know this rework might break several user space tools which are relying
> on the default raw access implementation (I already experienced an issue
> with the kobs-ng tool provided by freescale), but many other tools will
> now work as expected.
If the kobs-ng can not works, there is no meaning that other tools
works.  So I do not think we need to implement these hooks. 

sorry, I will not Ack this patch.

thanks
Huang Shijie
