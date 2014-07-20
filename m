Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaGTDQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 23:16:55 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45400 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaGTDQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 23:16:53 -0400
Message-ID: <53CB349E.50609@hitachi.com>
Date: Sun, 20 Jul 2014 12:16:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: Re: [PATCH v2 0/3] perf/sdt : Support for SDT markers
References: <20140717054826.19995.61782.stgit@hemant-fedora> <53C903B7.6070905@hitachi.com> <53CAABCB.5080202@linux.vnet.ibm.com>
In-Reply-To: <53CAABCB.5080202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/20 2:32), Hemant Kumar wrote:
>>> We have lots of applications which use SDT markers today, like:
>>> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
>>>
>>> To add SDT markers into user applications:
>>> We need to have this header sys/sdt.h present.
>>> sys/sdt.h used is version 3.
>>> If not present, install systemtap-sdt-devel package (for fedora-18).
>>>
>>> Please refer to the Documentation patch to see how the SDT markers are added into
>>> a program.
>>>
>>> With this patchset,
>>> - Use perf to list the markers in the app:
>>> # perf list sdt ./user_app
>>>
>>> ./user_app :
>>> %user_app:foo_start
>>> %user_app:fun_start
>>>
>>> - Also, we can see the SDT markers present in our system in the usual binaries.
>>> These usual binaries are libraries (dsos) listed by ldconfig --print-cache and some
>>> binaries present in PATH environment variable.
>>>
>>> First, scan the binaries using :
>>> # perf list sdt --scan
>> At a glance, maybe we'd better have perf sdt-cache as like as perf buildid-cache
>> for manage sdt information. what would you think?
>>
> 
> I agree with you having perf sdt-cache similar to perf buildid-cache.
> But I think if the functionality of perf sdt-cache is only to build the 
> cache, then we can
> go with the perf list sdt --scan. Since, "perf list sdt" is used for 
> other purposes too, it
> should be less confusing for the users to just add another option 
> (--scan) to create/modify
> the cache. What do you suggest?

I think there may be some other cases, for example adding user local build
binary to the cache, or remove/update it locally. :)

And also, in user's mental model of perf-list, it doesn't take an "active"
action, that always does "passive" action. So adding such "active" scan option
will be more confusing.

But I also think it is OK that if the sdt is never scanned, the perf-list
automatically scans in background (without any option) or suggests user
to run "perf sdt-cache --scan". (it depends on how long time it may take)

To summarize it, I'd like to suggest adding below functions;

perf list sdt : shows all cached SDT events
perf list sdt <file> : shows SDT events in <file>
perf sdt-cache --scan/-s : scans all system binaries/libraries + added files
perf sdt-cache --add/-a <file(s)> : add SDT events in <file> to cache
perf sdt-cache --remove/-r <file(s)>: remove SDT events in <file> from cache

And if perf list can't find sdt-cache, it would suggest to run
perf sdt-cache --scan or run it silently. :)

What would you think about this?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


