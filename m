Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaJVPs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:48:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:24518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbaJVPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,769,1406617200"; 
   d="scan'208";a="618589317"
Message-ID: <1413992885.2396.40.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/12] fs/seq_file: introduce seq_hex_dump() helper
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 22 Oct 2014 18:48:05 +0300
In-Reply-To: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 17:26 +0300, Andy Shevchenko wrote:
> This introduces a new helper and switches current users to use it. All are
> compiled tested, hexdump and kmemleak are tested by their test suits.
> 

Gently ping on this series.
Any comments?

> Changelog v4:
> - hexdump is amended to return value from which we can check an overflow
>  (patches 1/12 - 4/12)
> - seq_hex_dump pushes bytes directly to buffer and returns an error in case of
>   overflow (addresses Al Viro's comment)
> - append Acked-by for patches 8/12 and 9/12
> - convert more users (patches 10/12 - 12/12)
> 
> Changelog v3:
> - append Mauro's Ack
> - rebase on top of recent linux-next
> 
> Changelog v2:
> - append Acked-by and Reviewed-by tags
> - update commit messages in patches 3/5. and 5/5
> - update line size to be 32 bytes instead of 16 in patch 3/5
> - Joe found that output is changed in patch 4/5, thus I update commit message
>   there
> 
> Andy Shevchenko (12):
>   hexdump: introduce test suite
>   hexdump: fix ascii column for the tail of a dump
>   hexdump: do few calculations ahead
>   hexdump: makes it return amount of bytes placed in buffer
>   seq_file: provide an analogue of print_hex_dump()
>   saa7164: convert to seq_hex_dump()
>   crypto: qat - use seq_hex_dump() to dump buffers
>   parisc: use seq_hex_dump() to dump buffers
>   [S390] zcrypt: use seq_hex_dump() to dump buffers
>   staging: unisys: use seq_hex_dump() to dump buffers
>   kmemleak: use seq_hex_dump() to dump buffers
>   wil6210: use seq_hex_dump() to dump buffers
> 
>  .../crypto/qat/qat_common/adf_transport_debug.c    |  16 +-
>  drivers/media/pci/saa7164/saa7164-core.c           |  31 +---
>  drivers/net/wireless/ath/wil6210/debugfs.c         |  32 +---
>  drivers/parisc/ccio-dma.c                          |  14 +-
>  drivers/parisc/sba_iommu.c                         |  11 +-
>  drivers/s390/crypto/zcrypt_api.c                   |  10 +-
>  .../unisys/visorchannel/visorchannel_funcs.c       |  26 +--
>  fs/seq_file.c                                      |  50 ++++++
>  include/linux/printk.h                             |   6 +-
>  include/linux/seq_file.h                           |   4 +
>  lib/Kconfig.debug                                  |   3 +
>  lib/Makefile                                       |   4 +-
>  lib/hexdump.c                                      | 105 +++++++-----
>  lib/test-hexdump.c                                 | 180 +++++++++++++++++++++
>  mm/kmemleak.c                                      |  21 +--
>  15 files changed, 337 insertions(+), 176 deletions(-)
>  create mode 100644 lib/test-hexdump.c
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

