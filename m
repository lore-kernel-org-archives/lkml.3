Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaJUNsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:48:20 -0400
Received: from down.free-electrons.com ([37.187.137.238]:58321 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932529AbaJUNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:48:19 -0400
Date: Tue, 21 Oct 2014 15:48:15 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Ezaul Zillmer <ezaulzillmer@gmail.com>
Cc: linux-sunxi@googlegroups.com, computersforpeace@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yassinjaffer@gmail.com,
        maxime.ripard@free-electrons.com
Subject: Re: [PATCH v6 2/2] mtd: nand: add sunxi NFC dt bindings doc
Message-ID: <20141021154815.1ae4c879@bbrezillon>
In-Reply-To: <62d54110-9c7f-4342-9201-a1ae23194620@googlegroups.com>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413805520-14947-3-git-send-email-boris.brezillon@free-electrons.com>
	<20141021024134.GC1193@ld-irv-0074>
	<20141021145344.575b19e6@bbrezillon>
	<62d54110-9c7f-4342-9201-a1ae23194620@googlegroups.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 06:13:16 -0700 (PDT)
Ezaul Zillmer <ezaulzillmer@gmail.com> wrote:

> Hello everyone 
> 
> Boris Brezillon 
> 
> downloaded sunxi-nand-v6 now compiled for Cubieboard2 
> https://github.com/bbrezillon/linux-sunxi.git sunxi b-nand-v6 
> 
> u-boot 
> git clone https://github.com/jwrdegoede/u-boot-b sunxi.git sunxi-wip 
> 
> 
> [1.143903] nand: Could not find valid JEDEC parameter page; aborting 
> [1.150369] nand: device found, Manufacturer ID: 0xec, Chip ID: 0xd7 
> [1.156766] nand: Samsung NAND 4GiB 3.3V 8-bit 
> [1.161214] nand: 4096MiB, MLC, page size: 8192, OOB size: 640 
> [1.167167] sunxi_nand 1c03000.nand: ECC init failed: -22 
> [1.172588] sunxi_nand 1c03000.nand: failed to init nand chips 
> [1.178502] sunxi_nand: probe of 1c03000.nand failed with error -22 
> 
> need some more data?

No, this is still the same problem you had last time you asked:

You haven't defined your NAND chip in the nand_ids table, and thus
strength and size fields of the nand_ecc_ctrl struct are undefined...

You'll have to retrieve the whole READ_ID sequence and add a proper
entry in the nand_ids table (see [1] for an example).

Regards,

Boris

[1]https://github.com/bbrezillon/linux-sunxi/commit/da96d64e6ece81e717bbdcad28caf0e5a9c40995

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
