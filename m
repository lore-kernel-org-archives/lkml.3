Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab3DKSrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:47:40 -0400
Received: from www.sr71.net ([198.145.64.142]:49316 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304Ab3DKSri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:47:38 -0400
Message-ID: <51670549.70205@sr71.net>
Date: Thu, 11 Apr 2013 11:47:37 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
References: <515DBB00.20208@sr71.net> <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com> <5162E8DC.4080204@sr71.net> <20130411074529.GA1629@redhat.com>
In-Reply-To: <20130411074529.GA1629@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 12:45 AM, Stanislaw Gruszka wrote:
> On Mon, Apr 08, 2013 at 08:57:16AM -0700, Dave Hansen wrote:
>> On 04/04/2013 04:41 PM, Frederic Weisbecker wrote:
>>> Does this patch fix the issue for you?
>>> https://lkml.org/lkml/2013/4/4/112
>>
>> Nope, that doesn't seem to make a difference.  I'm still seeing the
>> underflow.  I'm pretty sure it's already gone to hell by the time it
>> gets in to the loop that's patched there.
> 
> Perhaps this is glich introduced by commit 
> 62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid multiplication
> overflow on utime scaling" . Could you try to revert it and see if that
> helps. If it does not, can you check if problem happen on 3.8 ?

I'll run a bit longer, but reverting
62188451f0d63add7ad0cd2a1ae269d600c1663d _does_ seem to make it happier.

