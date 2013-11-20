Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3KTRcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:32:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48365 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3KTRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:32:14 -0500
Message-ID: <528CF1F3.7020106@kernel.dk>
Date: Wed, 20 Nov 2013 10:31:31 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Hong Zhiguo <honkiko@gmail.com>
CC: vgoyal@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit
 stats
References: <1383736484-393-1-git-send-email-zhiguohong@tencent.com> <20131120172413.GN28946@htj.dyndns.org>
In-Reply-To: <20131120172413.GN28946@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 10:24 AM, Tejun Heo wrote:
> On Wed, Nov 06, 2013 at 07:14:44PM +0800, Hong Zhiguo wrote:
>> From: Hong Zhiguo <zhiguohong@tencent.com>
>>
>> Update of blkg_stat and blkg_rwstat may happen in bh context.
>> While u64_stats_fetch_retry is only preempt_disable on 32bit
>> UP system. This is not enough to avoid preemption by bh and
>> may read strange 64 bit value.
>>
>> Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Jens, can you please pick this one up?  This probably needs to be
> tagged for stable too.

Yeah will do, thanks.

-- 
Jens Axboe

