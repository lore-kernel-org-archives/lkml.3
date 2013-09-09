Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3IISNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:13:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57681 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IISNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:13:30 -0400
Message-ID: <522E0FA3.6060900@infradead.org>
Date: Mon, 09 Sep 2013 11:12:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: Re: linux-next: Tree for Sep 9 (ntb)
References: <20130909161616.0d663a37c9d5b6b3a2a2735a@canb.auug.org.au>
In-Reply-To: <20130909161616.0d663a37c9d5b6b3a2a2735a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/13 23:16, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any code for v3.13 to your linux-next included branches
> until after v3.12-rc1 is released.
> 
> Changes since 20130906:
> 


on x86_64:

drivers/built-in.o: In function `ntb_transport_free_queue':
(.text+0x150344): undefined reference to `dma_sync_wait'
drivers/built-in.o: In function `ntb_transport_create_queue':
(.text+0x1504b5): undefined reference to `dma_find_channel'
drivers/built-in.o: In function `ntb_transport_rx':
ntb_transport.c:(.text+0x150c65): undefined reference to `dma_sync_wait'


ntb_transport.c uses several dma_*() interfaces.
It looks like it needs to select DMA_ENGINE at a minimum.


-- 
~Randy
