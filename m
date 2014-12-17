Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaLQMtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:49:12 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52114 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLQMtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:49:11 -0500
Message-ID: <54917BCC.9070001@arm.com>
Date: Wed, 17 Dec 2014 12:49:16 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>, Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] SCHED_DEADLINE fixes
References: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
In-Reply-To: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
X-OriginalArrivalTime: 17 Dec 2014 12:49:07.0590 (UTC) FILETIME=[D8A2AA60:01D019F7]
X-MC-Unique: 114121712490814901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On 17/12/14 10:50, Luca Abeni wrote:
> Hi all,
> 
> I noticed some discrepancies between the schedule produced
> by SCHED_DEADLINE and the expectations from real-time
> scheduling theory. After some investigations, it turned out
> that such discrepancies are due to two bugs in deadline.c,
> which are particularly visible when using global scheduling
> on multiple CPUs (see the two patches for more details).
> 
> I think the first bug (fixed in patch 0001) is particularly
> critical, because it causes a violation of the SCHED_DEADLINE
> guarantee (if the total load is smaller than the number of
> CPUs, there is an upper bound for the response times. This is
> a well known property for global EDF, but is not respected by
> SCHED_DEADLINE - see patch 0001 for more details).
> The second patch is IMHO also important, but less critical.
> 

I already reviewed and tested them. They looks ok and are important
fixes. ACK for both. :)

Thanks a lot!

- Juri

> Luca Abeni (2):
>   Fix migration of SCHED_DEADLINE tasks
>   Avoid double-accounting in case of missed deadlines
> 
>  kernel/sched/deadline.c | 25 ++++---------------------
>  1 file changed, 4 insertions(+), 21 deletions(-)
> 

