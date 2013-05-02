Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab3EBQFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:05:31 -0400
Received: from www.sr71.net ([198.145.64.142]:56490 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab3EBQFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:05:30 -0400
Message-ID: <51828EC8.5090805@sr71.net>
Date: Thu, 02 May 2013 09:05:28 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
References: <515DBB00.20208@sr71.net> <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com> <5162E8DC.4080204@sr71.net> <20130411074529.GA1629@redhat.com> <51670549.70205@sr71.net> <20130416110651.GB620@redhat.com> <516DBD12.4030006@sr71.net> <20130430123634.GA10465@redhat.com>
In-Reply-To: <20130430123634.GA10465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 05:36 AM, Stanislaw Gruszka wrote:
> On Tue, Apr 16, 2013 at 02:05:22PM -0700, Dave Hansen wrote:
>>> But since this (most likely) is rtime monotonicity problem it
>>> is bug by itself and probably that should be fixed. Can you 
>>> check second patch attached and see if it trigger the warning.
>>
>> Yup, it triggers lots of warnings.  Here's one.
>>
>>> [  460.789710] ------------[ cut here ]------------
>>> [  460.789730] WARNING: at /home/davehans/linux.git/kernel/sched/cputime.c:563 cputime_adjust+0xe6/0xf0()
>>> [  460.789736] Hardware name: PRIMEQUEST 1800E2
>>> [  460.789739] Modules linked in:
>>> [  460.789745] Pid: 4245, comm: top Tainted: G        W    3.9.0-rc7-00004-gbb33db7-dirty #19
>>> [  460.789748] Call Trace:
>>> [  460.789777]  [<ffffffff810c6dc7>] warn_slowpath_common+0xb7/0x120
>>> [  460.789783]  [<ffffffff810c6e5a>] warn_slowpath_null+0x2a/0x40
>>> [  460.789789]  [<ffffffff8111a8d6>] cputime_adjust+0xe6/0xf0
>>> [  460.789795]  [<ffffffff8111b755>] ? thread_group_cputime+0x5/0x140
>>> [  460.789800]  [<ffffffff8111bbb9>] thread_group_cputime_adjusted+0x59/0x70
> 
> Dave, could you test attached patch and check if make warnings gone.
> Patch is not right fix, but if it prevent the warnings, this will
> give clue where the problem can be.

Does this have any relation to the other four -tip patches you also
posted?  What do you want this applied on top of?

