Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3DVBWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:22:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3DVBWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:22:49 -0400
Message-ID: <517490E0.9030704@ti.com>
Date: Sun, 21 Apr 2013 20:22:40 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <1366364534-3298-2-git-send-email-lars@metafoo.de> <5171C8F6.6010702@ti.com> <201304200113.02908.arnd@arndb.de>
In-Reply-To: <201304200113.02908.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.1.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/19/2013 06:13 PM, Arnd Bergmann wrote:
> On Saturday 20 April 2013, Jon Hunter wrote:
>> Change also means that of_dma_request_slave_channel() cannot be called
>> from a context where it is not possible to sleep too, right? May be
>> worth mentioning this in the changelog as well.
> 
> You already cannot do that, because it requires dma_list_mutex.

Right in the case where you use of_dma_simple_xlate(). However, someone
could implement whatever they wanted for the xlate. Probably not likely
as it needs to return struct dma_chan, but could be possible. That's
all. Not a big deal.

Cheers
Jon
