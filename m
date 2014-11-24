Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaKXKbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:31:36 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52809 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaKXKbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:31:35 -0500
Message-ID: <1416825092.10073.6.camel@x220>
Subject: MIPS: 64BIT_PHYS_ADDR
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 11:31:32 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2014 10:31:32.0550 (UTC) FILETIME=[D0BF4660:01D007D1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf,

Your commit 5bd35e65f101 ("MIPS: Replace MIPS-specific 64BIT_PHYS_ADDR
with generic PHYS_ADDR_T_64BIT") is included in today's linux-next (ie,
next-20141124). That commit does what it promises to do. There are a few
references to 64BIT_PHYS_ADDR in linux-next:
    $ git grep -n 64BIT_PHYS_ADDR 
    arch/mips/include/asm/pgtable-32.h:225:#endif /* defined(CONFIG_64BIT_PHYS_ADDR) && defined(CONFIG_CPU_MIPS32) */
    drivers/dma/txx9dmac.c:79:#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
    drivers/dma/txx9dmac.h:70:#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
    drivers/dma/txx9dmac.h:204:#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
    drivers/pcmcia/Kconfig:150:     select 64BIT_PHYS_ADDR
    drivers/pcmcia/Kconfig:161:     select 64BIT_PHYS_ADDR

I assume that patches to replace these references too are queued
somewhere. Is that correct?


Paul Bolle

