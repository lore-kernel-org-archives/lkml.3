Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaI2R06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:26:58 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:33178 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaI2R05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:26:57 -0400
Message-ID: <5429965F.2070806@hp.com>
Date: Mon, 29 Sep 2014 13:26:55 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct
 dsos
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com> <1411573540-8765-2-git-send-email-Waiman.Long@hp.com> <20140926141230.GB3879@kernel.org>
In-Reply-To: <20140926141230.GB3879@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 10:12 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
>> This is a precursor patch to enable long name searching of DSOs
>> using the rbtree. In this patch, a new dsos structure is created
>> which contains only a list head structure for the moment. The new
>> dsos structure is used, in turn, in the machine structure for the
>> user_dsos and kernel_dsos fields. Only the following 3 dsos functions
>> are modified to accept the new dsos structure parameter instead
>> of list_head:
>>   - dsos__add()
>>   - dsos__find()
>>   - __dsos__findnew()
>>
>> Because of the need to find out the corresponding dsos structure to
>> properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
>> a new dsos field is also added to the dso structure.
> What tree did you use to produce these patches? I just tried on my
> perf/core branch and I get some fuzzes:
>
> [acme@zoo linux]$ patch -p1<  /wb/1.patch
> patching file tools/perf/util/dso.c
> Hunk #1 succeeded at 755 (offset 2 lines).
> Hunk #2 succeeded at 852 (offset 2 lines).
> patching file tools/perf/util/dso.h
> patching file tools/perf/util/header.c
> patching file tools/perf/util/machine.c
> Hunk #2 succeeded at 72 (offset 2 lines).
> Hunk #3 succeeded at 477 (offset 29 lines).
> Hunk #4 succeeded at 994 (offset 29 lines).
> patching file tools/perf/util/machine.h
> Hunk #2 succeeded at 39 with fuzz 1 (offset 1 line).
> patching file tools/perf/util/probe-event.c
> patching file tools/perf/util/symbol-elf.c
> Hunk #1 succeeded at 929 (offset 13 lines).
> [acme@zoo linux]$
>
> I'll fix this up, probably harmless, just a heads up.
>
> - Arnaldo

I was using the latest linux 3.17 tree. I should have used the tip tree 
instead. I will use that if I need to sent out a new patch.

-Longman
