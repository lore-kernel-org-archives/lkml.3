Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaENDV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:21:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57612 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaENDVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:21:55 -0400
Message-ID: <5372E148.7050805@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 11:21:44 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com>
In-Reply-To: <53721FD4.6060300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051403-5140-0000-0000-0000051CF7EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 09:36 PM, Rik van Riel wrote:
[snip]
>>
>> echo 2048 > /cgroup/c/cpu.shares
>>
>> Where [ABC].sh are spinners:
> 
> I suspect the "are spinners" is key.
> 
> Infinite loops can run all the time, while dbench spends a lot of
> its time waiting for locks. That waiting may interfere with getting
> as much CPU as it wants.

That's what we are thinking, also we assume that by introducing load
decay mechanism, it become harder for the sleepy tasks to gain enough
slice, well, that currently just imagination, more investigation is
needed ;-)

Regards,
Michael Wang

> 

