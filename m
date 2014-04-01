Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaDABqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:46:33 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40072 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaDABqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:46:30 -0400
Date: Mon, 31 Mar 2014 18:46:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: diskonchip: mem resource name is not optional
Message-ID: <20140401014627.GG29542@ld-irv-0074>
References: <1395267877-15223-1-git-send-email-sasha.levin@oracle.com>
 <1395477572.57478225@f224.i.mail.ru>
 <533765F8.2090700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <533765F8.2090700@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 08:31:52PM -0400, Sasha Levin wrote:
> On 03/22/2014 04:39 AM, Alexander Shiyan wrote:
> >Wed, 19 Mar 2014 18:24:37 -0400 от Sasha Levin <sasha.levin@oracle.com>:
> >>Passing a name to request_mem_region() isn't optional and can't just
> >>be NULL. Passing NULL causes a NULL ptr deref later in the boot
> >>process.
> >>
> >>Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >>---
> >>  drivers/mtd/nand/diskonchip.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
> >>index b9b4db6..f68a7bc 100644
> >>--- a/drivers/mtd/nand/diskonchip.c
> >>+++ b/drivers/mtd/nand/diskonchip.c
> >>@@ -1439,7 +1439,7 @@ static int __init doc_probe(unsigned long physadr)
> >>  	int reg, len, numchips;
> >>  	int ret = 0;
> >>
> >>-	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, NULL))
> >>+	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, "DiskOnChip"))
> >>  		return -EBUSY;
> >>  	virtadr = ioremap(physadr, DOC_IOREMAP_LEN);
> >>  	if (!virtadr) {
> >>--
> >
> >Tested-by: Alexander Shiyan <shc_work@mail.ru>
> 
> It seems that no one pulled this patch anywhere. It fixes a straightforward
> boot failure on boot when diskonchip is enabled in the config.
> 
> Someone grab it please?

Pushed to l2-mtd.git, marked for stable >= 3.14.

Brian
