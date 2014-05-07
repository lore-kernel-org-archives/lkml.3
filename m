Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaEGNEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:04:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbaEGNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:04:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,1003,1389715200"; 
   d="scan'208";a="30200079"
Message-ID: <536A2143.5090106@cn.fujitsu.com>
Date: Wed, 7 May 2014 21:04:19 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/clock: cleanup, remove wrap_{max|min}().
References: <1399463338-15507-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140507125548.GL30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140507125548.GL30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 09:55 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 08:48:58PM +0900, Dongsheng Yang wrote:
>> I am not sure why we need the wrap_{max|min}() in kernel/sched/clock.c.
>> But I checked the implementation of max() and min() in linux/kernel.h, I think
>> we can reuse them here rather than introduce a new function named
>> wrap_{max|min}().
> wrap is a good hint there.. they're supposed to deal with the clock
> wrapping. Of course 2^64 ns is a rather long time (~584 years in fact),
> but that doesn't mean we shouldn't care.
>
> And no, min/max don't do the right thing.

IMMO,  max() in kernel.h is checking and returning the u64 with typeof() if
we are passing a u64 parameter to max(). And I checked current callers 
of wrap_max(),
they are all passing parameters of u64 type. So I think max/min works 
well at
the place of wrap_max/min().

Maybe I am missing something here, please correct me if I understand it 
incorrectly.

Thanx
