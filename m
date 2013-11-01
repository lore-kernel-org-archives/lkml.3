Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3KAOtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3KAOtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:49:32 -0400
Message-ID: <5273BF62.6050903@redhat.com>
Date: Fri, 01 Nov 2013 10:49:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 -tip] fix race between stop_two_cpus and stop_cpus
References: <20131031163144.0fd27457@annuminas.surriel.com> <20131101110825.GX2400@suse.de> <52739244.3060209@redhat.com> <20131101134424.GA32685@suse.de> <20131101142404.GG19466@laptop.lan> <5273BA58.6010404@redhat.com> <20131101104146.03d1e043@annuminas.surriel.com> <20131101144728.GY2400@suse.de>
In-Reply-To: <20131101144728.GY2400@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/01/2013 10:47 AM, Mel Gorman wrote:
> On Fri, Nov 01, 2013 at 10:41:46AM -0400, Rik van Riel wrote:
>> Subject: fix race between stop_two_cpus and stop_cpus
>>
>> There is a race between stop_two_cpus, and the global stop_cpus.
>>
>> It is possible for two CPUs to get their stopper functions queued
>> "backwards" from one another, resulting in the stopper threads
>> getting stuck, and the system hanging. This can happen because
>> queuing up stoppers is not synchronized.
>>
>> This patch adds synchronization between stop_cpus (a rare operation),
>> and stop_two_cpus.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>> v2: use lglock, as suggested by Peter & Mel, thanks to both of you
>> for insisting on nicer code :)
>>
> 
> This is a tad more comprehensible :). Thanks!
> 
> Acked-by: Mel Gorman <mgorman@suse.de>

I'll test for a few hours and get back to everyone by the end of the day.

P.

> 
