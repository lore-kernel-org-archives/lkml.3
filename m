Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaEIQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:41:27 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44813 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaEIQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:41:26 -0400
Message-ID: <536D0537.7010905@kernel.dk>
Date: Fri, 09 May 2014 10:41:27 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>, sbradshaw@micron.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
References: <1399627061-5960-1-git-send-email-m@bjorling.me> <1399627061-5960-2-git-send-email-m@bjorling.me> <536CE25C.5040107@kernel.dk>
In-Reply-To: <536CE25C.5040107@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 08:12 AM, Jens Axboe wrote:
> On 05/09/2014 03:17 AM, Matias Bjørling wrote:
>> With multi-million IOPS and multi-node workloads, the atomic_t in_flight
>> tracking becomes a bottleneck. Change the in-flight accounting to per-cpu
>> counters to elevate.
> 
> The part stats are a pain in the butt, I've tried to come up with a
> great fix for them too. But I don't think the percpu conversion is
> necessarily the right one. The summing is part of the hotpath, so percpu
> counters aren't necessarily the right way to go. I don't have a better
> answer right now, otherwise it would have been fixed :-)

Actual data point - this slows my test down ~14% compared to the stock
kernel. Also, if you experiment with this, you need to watch for the
out-of-core users of the part stats (like DM).

-- 
Jens Axboe

