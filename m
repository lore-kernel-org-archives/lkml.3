Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219Ab3E2NnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:43:01 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33011 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586Ab3E2Nm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <51A5DEDC.4040606@nvidia.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369656882-25241-10-git-send-email-andriy.shevchenko@linux.intel.com>
	<51A5DEDC.4040606@nvidia.com>
Date: Wed, 29 May 2013 16:42:56 +0300
Message-ID: <CAHp75Vfib7ogMcPp83u3=EfuzzSzZyRGGw8W1=m5qeWtcYp3Hw@mail.gmail.com>
Subject: Re: [PATCH 09/12] tegra20-apb-dma: remove useless use of lock
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 1:56 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Monday 27 May 2013 05:44 PM, Andy Shevchenko wrote:
>>
>> Accordingly to dma_cookie_status() description locking is not required.
>>
> I think we need lock here:
> From isr handler, we call dma_cookie_complete() which is in spin-locked.
> This function updates  tx->chan->completed_cookie = tx->cookie;
> In tegra_dma_tx_status(), we check for dma_cookie_status() which access the
> chan->completed_cookie; and it decides status based on this
>
> As the access of  chan->completed_cookie  are from different context, we
> need this locking.

You need to have a consistent data in the cookies. This is guaranteed
by memory barrier if I got it correctly.

-- 
With Best Regards,
Andy Shevchenko
