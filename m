Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3BFIei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:34:38 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57199
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab3BFIef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:34:35 -0500
Date: Wed, 6 Feb 2013 09:33:28 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        josh.h.morris@us.ibm.com,
        Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20130206083328.GC15092@kernel.dk>
References: <20130206140623.04297c3ac2f0fa3437369ffe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206140623.04297c3ac2f0fa3437369ffe@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06 2013, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/block/rsxx/core.c:322:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'rsxx_pci_probe'
> drivers/block/rsxx/core.c:513:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'rsxx_pci_remove'
> drivers/block/rsxx/core.c:610:12: error: 'rsxx_pci_probe' undeclared here (not in a function)
> drivers/block/rsxx/core.c:611:2: error: implicit declaration of function '__devexit_p' [-Werror=implicit-function-declaration]
> drivers/block/rsxx/core.c:611:25: error: 'rsxx_pci_remove' undeclared here (not in a function)
> drivers/block/rsxx/core.c:51:8: warning: 'rsxx_disk_ida' defined but not used [-Wunused-variable]
> drivers/block/rsxx/core.c:52:8: warning: 'rsxx_ida_lock' defined but not used [-Wunused-variable]
> drivers/block/rsxx/core.c:219:13: warning: 'card_event_handler' defined but not used [-Wunused-function]
> drivers/block/rsxx/core.c:311:12: warning: 'rsxx_compatibility_check' defined but not used [-Wunused-function]
> 
> Caused by commit 8722ff8cdbfa ("block: IBM RamSan 70/80 device driver")
> interacting with commit 54b956b90360 ("Remove __dev* markings from
> init.h") from Linus' tree (as of v3.8-rc4).
> 
> I added the following merge fix patch:

Thanks Stephen, I merged it into the for-3.9/drivers branch and updated
for-next.

-- 
Jens Axboe

