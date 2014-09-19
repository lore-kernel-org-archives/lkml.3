Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaISMp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:45:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48415 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaISMpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:45:55 -0400
Message-ID: <541C259E.4010207@arm.com>
Date: Fri, 19 Sep 2014 13:46:22 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-3-git-send-email-juri.lelli@arm.com> <541C17D6.5020608@bmw-carit.de>
In-Reply-To: <541C17D6.5020608@bmw-carit.de>
X-OriginalArrivalTime: 19 Sep 2014 12:45:52.0490 (UTC) FILETIME=[A59504A0:01CFD407]
X-MC-Unique: 114091913455207301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 19/09/14 12:47, Daniel Wagner wrote:
> Hi,
> 
> On 09/19/2014 11:22 AM, Juri Lelli wrote:
>> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
>> affinity (performing what is commonly called clustered scheduling).
>> Unfortunately, such thing is currently broken for two reasons:
>>
>>  - No check is performed when the user tries to attach a task to
>>    an exlusive cpuset (recall that exclusive cpusets have an
>>    associated maximum allowed bandwidth).
>>
>>  - Bandwidths of source and destination cpusets are not correctly
>>    updated after a task is migrated between them.
>>
>> This patch fixes both things at once, as they are opposite faces
>> of the same coin.
>>
>> The check is performed in cpuset_can_attach(), as there aren't any
>> points of failure after that function. The updated is split in two
>> halves. We first reserve bandwidth in the destination cpuset, after
>> we pass the check in cpuset_can_attach(). And we then release
>> bandwidth from the source cpuset when the task's affinity is
>> actually changed. Even if there can be time windows when sched_setattr()
>> may erroneously fail in the source cpuset, we are fine with it, as
>> we can't perfom an atomic update of both cpusets at once.
>>
>> Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Ack
> 
> I have no special test for this, I just let my test running which was
> fixed by patch #1. Works fine though. I'll plan to write some test for this.
> 

Ok, thanks. Just mind that the problem fixed by patch 3/3 may sometime
affect this too. I should have definitely put 3/3 on top of the patchset :/.

Thanks,

- Juri

