Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaEEQhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:37:50 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62659 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaEEQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:37:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140502151250.GB10204@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
	<CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
	<20140502151250.GB10204@htj.dyndns.org>
Date: Mon, 5 May 2014 22:07:47 +0530
Message-ID: <CAC4Lta1rmtXeFBAJB_YA8wS9BHqkMSLAsV6q=obf_aQ--aud-Q@mail.gmail.com>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/14, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Apr 30, 2014 at 04:27:51PM +0530, Raghavendra KT wrote:
[...]
>> Because all the way along, though we have freedom to make the cpusets
>> exclusive and move tasks (say VMs) into them,
>> making sure they do not interfere with each other, we can not prevent
>> the other tasks spawned in a system eating into cpus of
>> exclusive cpuset since they go to root automatically.
>
> I believe the right thing to do would be starting / confining other
> tasks in the appropriate non-root cgroups.  cgroup already provides
> mechanisms to achieve that.  The rest is upto userland.
>

Thanks Tejun for the reply. I agree.

>> Do you think having a knob, to make sure new tasks spawned go to say a
>> default  directory under root makes sense?
>>
>>  I understand that we could easily have a userspace script which could
>> achieve intended goal, but kernel solution
>>  would really make the exclusive cpusets have exclusive access to cpus
>> it should have.
>
> This would just be a more reliable implementation of an ad-hoc
> mechanism when it can already be properly achieved by managing cgroups
> of all processes in the system.

Correct. Perhaps your answer clears my dilemma to go for a userspace
since I donot have any strong reason except convenience to go for a
kernel solution.
