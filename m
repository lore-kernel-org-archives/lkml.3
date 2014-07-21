Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaGUC3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:29:43 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:53883 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaGUC3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:29:42 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 0/3] perf/sdt : Support for SDT markers
References: <20140717054826.19995.61782.stgit@hemant-fedora>
	<53C903B7.6070905@hitachi.com> <53CAABCB.5080202@linux.vnet.ibm.com>
	<53CB349E.50609@hitachi.com>
Date: Mon, 21 Jul 2014 11:29:39 +0900
In-Reply-To: <53CB349E.50609@hitachi.com> (Masami Hiramatsu's message of "Sun,
	20 Jul 2014 12:16:46 +0900")
Message-ID: <874mybla0c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami and Hemant,

On Sun, 20 Jul 2014 12:16:46 +0900, Masami Hiramatsu wrote:
> (2014/07/20 2:32), Hemant Kumar wrote:
>>>> We have lots of applications which use SDT markers today, like:
>>>> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
>>>>
>>>> To add SDT markers into user applications:
>>>> We need to have this header sys/sdt.h present.
>>>> sys/sdt.h used is version 3.
>>>> If not present, install systemtap-sdt-devel package (for fedora-18).
>>>>
>>>> Please refer to the Documentation patch to see how the SDT markers are added into
>>>> a program.
>>>>
>>>> With this patchset,
>>>> - Use perf to list the markers in the app:
>>>> # perf list sdt ./user_app
>>>>
>>>> ./user_app :
>>>> %user_app:foo_start
>>>> %user_app:fun_start
>>>>
>>>> - Also, we can see the SDT markers present in our system in the usual binaries.
>>>> These usual binaries are libraries (dsos) listed by ldconfig --print-cache and some
>>>> binaries present in PATH environment variable.
>>>>
>>>> First, scan the binaries using :
>>>> # perf list sdt --scan
>>> At a glance, maybe we'd better have perf sdt-cache as like as perf buildid-cache
>>> for manage sdt information. what would you think?
>>>
>> 
>> I agree with you having perf sdt-cache similar to perf buildid-cache.
>> But I think if the functionality of perf sdt-cache is only to build the 
>> cache, then we can
>> go with the perf list sdt --scan. Since, "perf list sdt" is used for 
>> other purposes too, it
>> should be less confusing for the users to just add another option 
>> (--scan) to create/modify
>> the cache. What do you suggest?
>
> I think there may be some other cases, for example adding user local build
> binary to the cache, or remove/update it locally. :)
>
> And also, in user's mental model of perf-list, it doesn't take an "active"
> action, that always does "passive" action. So adding such "active" scan option
> will be more confusing.
>
> But I also think it is OK that if the sdt is never scanned, the perf-list
> automatically scans in background (without any option) or suggests user
> to run "perf sdt-cache --scan". (it depends on how long time it may take)
>
> To summarize it, I'd like to suggest adding below functions;
>
> perf list sdt : shows all cached SDT events
> perf list sdt <file> : shows SDT events in <file>
> perf sdt-cache --scan/-s : scans all system binaries/libraries + added files
> perf sdt-cache --add/-a <file(s)> : add SDT events in <file> to cache
> perf sdt-cache --remove/-r <file(s)>: remove SDT events in <file> from cache
>
> And if perf list can't find sdt-cache, it would suggest to run
> perf sdt-cache --scan or run it silently. :)
>
> What would you think about this?

I agree with Masami's idea.  Maybe we can add a config option for the
auto-scan thing.

And I think this series can be split to pieces for ease review. :)
IOW, please consider make it something like below steps:

  1. add raw SDT parsing code
  2. support perf list to print SDT markers from a single file
  3. implement perf sdt-cache like Masami suggested
  4. improve perf list sdt to use cached result


I guess it's easy to make a progress on step 1 and 2.  And we can
discuss further how to shape/improve step 3 and 4 later.

Thanks,
Namhyung
