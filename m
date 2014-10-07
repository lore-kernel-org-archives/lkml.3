Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaJGMCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:02:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38407 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaJGMCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:02:30 -0400
Message-ID: <5433D654.2020108@monom.org>
Date: Tue, 07 Oct 2014 14:02:28 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de> <5433B5B9.70006@arm.com>
In-Reply-To: <5433B5B9.70006@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,

On 10/07/2014 11:43 AM, Juri Lelli wrote:
> Hi Daniel,
> 
> On 24/09/14 14:24, Daniel Wagner wrote:
>> When a PI mutex is shared between an deadline task and normal task we
>> might end up trying to replenish from the normal task. In this case neither
>> dl_runtime, dl_period or dl_deadline are set. replenish_dl_entity() can't do
>> anything useful.
>>
> 
> Is this same bug we have with rt_mutex_setprio or something different?
> I'm sorry, but I don't remember anymore :/. It looks like a different
> issue, though.

There are two independent bugs but in both cases BUG_ON in
enqueue_dl_entity() is triggered.

The first one (this patch) is triggered by trying to use the sched_attr
of the non deadline task. The second one is the double queuing.

> Anyway, the callpath you talked about on IRC seems to make sense, does
> what below fix the thing?

I'll give it a spin.

> Could you please point me again to where the
> tests you are running are hosted, so that I can easily reproduce the
> bug here?

Sure. I reduced my original program to this:

http://www.monom.org/rt/pthread_test.c

If you let it run with 'pthread_test inherit' you should see the bugs
eventually.

cheers,
daniel
