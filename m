Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJWFbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:31:24 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47658 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWFbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:31:23 -0400
Message-ID: <54489298.3010108@linux.vnet.ibm.com>
Date: Thu, 23 Oct 2014 11:01:04 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105914.15506.84827.stgit@hemant-fedora> <54475292.20409@hitachi.com> <544768C6.6090105@linux.vnet.ibm.com> <54477BE6.2060006@hitachi.com>
In-Reply-To: <54477BE6.2060006@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102305-0017-0000-0000-00000065A5AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/22/2014 03:11 PM, Masami Hiramatsu wrote:
> (2014/10/22 17:20), Hemant Kumar wrote:
>>>>  From "file_sdt_ent" we will find out the file name.
>>>> Convert this sdt note into a perf event and then write this into uprobe_events
>>>> file to be able to record the event.
>>>> Then, corresponding entries are added to uprobe_events file for
>>>> the SDT events.
>>>> After recording is done, these events are silently deleted from uprobe_events
>>>> file. The uprobe_events file is present in debugfs/tracing directory.
>>>>
>>>> To support the addition and deletion of SDT events to/from uprobe_events
>>>> file, a record_sdt struct is maintained which has the event data.
>>> OK, I have some comments on this.
>>>
>>>> An example usage:
>>>>
>>>> # ./perf record -e %user_app:fun_start -aR /home/user_app
>>> At first, I'd like to add SDT support for adding probes too, like below;
>>>
>>> ./perf probe -a '%user_app:fun_start $vars'
>> But I think, previously we discussed that we won't be having "perf
>> probe" for SDT events.
>> We list them and probe/trace them using "perf record" directly.
> Right, sorry for confusing you. I meant that I'd like to support SDT on both of
> perf-record and perf-probe :)

I plan to do this and add this subsequently but will it be okay if we go 
with the current
implementation for the time being?

What do you think?

> And even if we'll hide sdt related events via perf, users can access it via ftrace.
> So, I doubt that we can completely hide them, in that case, honesty is the best way;)
>
> Thank you,
>
>

-- 
Thanks,
Hemant Kumar

