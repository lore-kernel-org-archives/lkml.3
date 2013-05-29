Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661Ab3E2Kza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:55:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14196 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2Kz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:55:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 May 2013 03:55:16 -0700
Message-ID: <51A5DEDC.4040606@nvidia.com>
Date: Wed, 29 May 2013 16:26:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 09/12] tegra20-apb-dma: remove useless use of lock
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com> <1369656882-25241-10-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369656882-25241-10-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013 05:44 PM, Andy Shevchenko wrote:
> Accordingly to dma_cookie_status() description locking is not required.
>
I think we need lock here:
 From isr handler, we call dma_cookie_complete() which is in 
spin-locked. This function updates  tx->chan->completed_cookie = tx->cookie;
In tegra_dma_tx_status(), we check for dma_cookie_status() which access 
the chan->completed_cookie; and it decides status based on this

As the access of  chan->completed_cookie  are from different context, we 
need this locking.

But did not get why it is documented as locking is not require if shared 
variable is getting changed/access from different context simultaneously.

