Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaDCOSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaDCOSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:18:46 -0400
Message-ID: <533D6D9E.1020401@redhat.com>
Date: Thu, 03 Apr 2014 10:18:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@redhat.com,
        peterz@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix tracepoint in scheduler.
References: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 08:12 AM, Dongsheng Yang wrote:
> In function set_task_cpu(), if cpu == new_cpu,
> there is no migration happen. But current trace point
> will raise a migration trace event.
> 
> This patch change trace point to right place,
> only when migration really happen, an event will
> be threw out.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

I don't see any obvious place where set_task_cpu is called
with cpu == new_cpu, but there might be an un-obvious place,
because that if looks like it's there for a reason :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
