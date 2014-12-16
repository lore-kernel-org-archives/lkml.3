Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaLPR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:29:37 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41071 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaLPR3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:29:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu>
	<20141215220150.GP9845@kernel.org>
	<CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com>
	<alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 16 Dec 2014 12:29:35 -0500
Message-ID: <CABPqkBQaJbvWj-3gdCTMLuynNEYm7qtx1ESCwUC--BfZX9P+FA@mail.gmail.com>
Subject: Re: [perf tool] cgroup support broken on Debian?
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

On Tue, Dec 16, 2014 at 12:17 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> On Mon, 15 Dec 2014, Stephane Eranian wrote:
>> On Mon, Dec 15, 2014 at 11:01 PM, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
>
>> fs is visible. The cgroup file system type is not there anymore. They are using
>> tmpfs which is not ideal to detect just cgroup. Looks like now, we have to look
>> at the mount point which is flaky.
>
> The trivial fix is to just always assume things will be under
>         /sys/fs/cgroup
> which looks like to be the new official mount point.
>
> This will break on older systems though, or systems that mount cgroupfs in
> multiple locations.
>
> Another alternative is to change the interface to require the full
> cgroupfs pathname as an argument to -G
>
That's not user friendly!
We need to detect where this is mounted to.
I think we can try the tmpfs mount points. Just need to then check if
a file entry
that can only exist for cgroups is there, such as cgroups.procs.

>> Yes, the error needs to be improved or even added. The following common
>> errors are encountered:
>>
>> - -G option requires -a (system-wide), otherwise it does not work at all
>> - -G option must always be specified AFTER the ALL event list
>> - -G and explicit event groups is not well supported by the tool yet.
>> An event group must have the same cgroup.
>> - Cgroups are specified per event
>> - -G cgroup order follows the event order: -e e1, e2, e3 -G g1,g2,g3:
>> g1->e1, g2->e2, g3->e3
>> - It is possible to indicate no cgroup with -G: -e e1,e2,e3 -G g1,,g3
>> using empty group (,,)
>
> I'll see if I can get a patch together that impements this.
>
> Vince
