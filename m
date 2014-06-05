Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaFECOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:14:10 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65471 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaFECOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:14:08 -0400
Message-ID: <538FD268.1080809@kernel.dk>
Date: Wed, 04 Jun 2014 20:14:00 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>
CC: Paolo Valente <paolo.valente@unimore.it>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it> <20140530232804.GA5057@htj.dyndns.org> <20140602111432.GA3737@amd.pavel.ucw.cz> <20140602173332.GB8912@htj.dyndns.org> <20140604223152.GA7881@amd.pavel.ucw.cz>
In-Reply-To: <20140604223152.GA7881@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 16:31, Pavel Machek wrote:
> Hi!
>
> On Mon 2014-06-02 13:33:32, Tejun Heo wrote:
>> On Mon, Jun 02, 2014 at 01:14:33PM +0200, Pavel Machek wrote:
>>> Now.. I see it is more work for storage maintainers, because there'll
>>> be more code to maintain in the interim. But perhaps user advantages
>>> are worth it?
>>
>> I'm quite skeptical about going that route.  Not necessarily because
>> of the extra amount of work but more the higher probability of getting
>> into situation where we can neither push forward or back out.  It's
>> difficult to define clear deadline and there will likely be unforeseen
>> challenges in the planned convergence of the two schedulers,
>> eventually, it isn't too unlikely to be in a situation where we have
>> to admit defeat and just keep both schedulers.  Note that developer
>
> Yes, that might happen. But it appears that conditions that would
> make us stuck with CFQ&BFQ are the same conditions that would make us
> stuck with CFQ alone.

We're not merging BFQ as is. The plan has to be to merge the changes 
into CFQ, leaving us with both a single scheduler, and with a clear path 
both backwards and forwards. This was all mentioned earlier in this 
thread as well. The latter part of the patch series is already nicely 
geared towards this, it's just the first part that has to be done as 
well. THAT is the way forward for BFQ.

> And if BFQ is really better for interactivity under load, I'd really
> really like option to use it, even if it leads to regression under
> batch loads (or something else)...

The benefit is that BFQ has (most) everything nicely characterized, not 
that it is necessarily a lot better for any possible workload out there. 
As you saw yourself, there can be (and are) bugs lurking that can cause 
crashes. Another instance has been reported where there's a huge 
performance regression. Especially the latter would be a lot easier to 
debug, if it could be pin-pointed down to a specific single change. And 
I'm sure there are other issues as well, similarly to where there's 
undoubtedly cases where BFQ works better.

>> overhead isn't the only factor here.  Providing two slightly different
>> alternatives inevitably makes userland grow dependencies on subtleties
>> of both and there's a lot less pressure to make judgement calls and
>
> Dunno. It is just the scheduler. It makes stuff slower or faster, but
> should not affect userland too badly.

Until userland starts depending on various sysfs exports to tweak behavior.

-- 
Jens Axboe

