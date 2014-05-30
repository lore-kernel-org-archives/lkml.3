Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaE3RUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:20:30 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55133 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaE3RU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:20:29 -0400
Message-ID: <5388BDD8.9000202@bjorling.me>
Date: Fri, 30 May 2014 19:20:24 +0200
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
CC: willy@linux.intel.com, sbradshaw@micron.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] NVMe: basic conversion to blk-mq
References: <1401317998-8980-1-git-send-email-m@bjorling.me> <1401317998-8980-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1405281929460.4995@AMR> <53874374.2020302@kernel.dk> <alpine.LRH.2.03.1405291601150.25112@AMR> <5387BD73.9030607@kernel.dk> <5387BEE5.6060007@kernel.dk>
In-Reply-To: <5387BEE5.6060007@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:12 AM, Jens Axboe wrote:
> On 05/29/2014 05:06 PM, Jens Axboe wrote:
>> Ah I see, yes that code apparently got axed. The attached patch brings
>> it back. Totally untested, I'll try and synthetically hit it to ensure
>> that it does work. Note that it currently does unmap and iod free, so
>> the request comes back pristine. We could preserve that if we really
>> wanted to, I'm guessing it's not a big deal.
> 
> And another totally untested patch that retains the iod and dma mapping
> on the requeue event. Again, probably not a big deal, I'm assuming these
> happen rarely, but it's simple enough to do.
> 

Thanks. I've added it and rebased nvmemq_wip_review on the latest 3.16/core.
