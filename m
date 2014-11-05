Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKEVCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:02:12 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33297 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKEVCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:02:10 -0500
Date: Wed, 5 Nov 2014 13:02:06 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        sojkam1@fel.cvut.cz, michal.vokac@comap.cz,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v4] mtd: nand: omap: Synchronize the access to the ECC
 engine
Message-ID: <20141105210206.GS23619@ld-irv-0074>
References: <1414577459-26135-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414577459-26135-1-git-send-email-lisovy@merica.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:10:59AM +0100, Rostislav Lisovy wrote:
> The AM335x Technical Reference Manual (spruh73j.pdf) says
> "Because the ECC engine includes only one accumulation context,
> it can be allocated to only one chip-select at a time ... "
> (7.1.3.3.12.3). Since the commit 97a288ba2cfa ("ARM: omap2+:
> gpmc-nand: Use dynamic platform_device_alloc()") gpmc-nand
> driver supports multiple NAND flash devices connected to
> the single controller.
> Use global 'struct nand_hw_control' among multiple NAND
> instances to synchronize the access to the single ECC Engine.
> 
> Tested with custom AM335x board using 2x NAND flash chips.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> Acked-by: Roger Quadros <rogerq@ti.com>
> ---
> Changes since v3:
> * Make the omap_gpmc_controller static (Frans Klaver)
> 
> Changes since v2:
> * Do not use custom locks. Use global 'struct nand_hw_control'
>   among multiple NAND instances and it will do the work for us
>   (Roger Quadros)
> 
> Changes since v1:
> * Since not all the read/write operations are performed by the
>   omap_read(write)_page_bch() functions use the locks directly on
>   those places that configure the ECC engine (take the lock) and
>   read the result from the ECC engine (release the lock).
>   This approach should cover read/write operations with all
>   possible ECC modes. (Roger Quadros)

Pushed to l2-mtd.git. Thanks!

Brian
