Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaFDUIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:08:50 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52161 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaFDUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:08:48 -0400
Message-ID: <538F7CCE.3050508@kernel.dk>
Date: Wed, 04 Jun 2014 14:08:46 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        Shaohua Li <shli@kernel.org>
CC: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
References: <1399627061-5960-1-git-send-email-m@bjorling.me>	<1399627061-5960-2-git-send-email-m@bjorling.me>	<536CE25C.5040107@kernel.dk>	<536D0537.7010905@kernel.dk>	<20140530121119.GA1637@kernel.org>	<53888C80.2020206@kernel.dk>	<20140604103901.GA14383@kernel.org> <CAOu_J6nRZuktyozjychkLOA+1zwct2+7KPUxfNAghVOOOBfi+g@mail.gmail.com>
In-Reply-To: <CAOu_J6nRZuktyozjychkLOA+1zwct2+7KPUxfNAghVOOOBfi+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:29 AM, Matias Bjørling wrote:
> It's in
> 
> blk_io_account_start
>   part_round_stats
>     part_round_state_single
>       part_in_flight
> 
> I like the granularity idea.

And similarly from blk_io_account_done() - which makes it even worse,
since it at both ends of the IO chain.

-- 
Jens Axboe

