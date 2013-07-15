Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3GOKAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:00:49 -0400
Received: from relay.parallels.com ([195.214.232.42]:35291 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3GOKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:00:48 -0400
Message-ID: <51E3C84A.5090403@parallels.com>
Date: Mon, 15 Jul 2013 14:00:42 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, <pjt@google.com>
Subject: Re: [PATCH RFC] sched: move h_load calculation to task_h_load
References: <1373705235-22523-1-git-send-email-vdavydov@parallels.com> <20130715082853.GM17211@twins.programming.kicks-ass.net>
In-Reply-To: <20130715082853.GM17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.24.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 12:28 PM, Peter Zijlstra wrote:
> OK, fair enough. It does somewhat rely on us getting the single
> rq->clock update thing right, but that should be ok.

Frankly, I doubt that rq->clock is the right thing to use here, because 
it can be updated very frequently under some conditions, so that 
cfs_rq->h_load can get updated several times during the same balance 
run. Perhaps, jiffies would suit better for that purpose. This would 
work as h_load update throttler similar to how it works now (I mean 
rq->h_load_throttle in update_h_load()).

If there is something else you don't like/have some thoughts on, please 
share - I'll try to improve.

Thank you for your feedback.

> But yeah, when you have stupid many cgroups we quickly need less h_load
> instances than there are cgroups.
