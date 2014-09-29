Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaI2Sku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:40:50 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41686 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaI2Skt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:40:49 -0400
Message-ID: <5429A7AE.9030707@hp.com>
Date: Mon, 29 Sep 2014 14:40:46 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct
 dsos
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com> <1411573540-8765-2-git-send-email-Waiman.Long@hp.com> <20140926140625.GA3879@kernel.org> <87h9zrhyjr.fsf@sejong.aot.lge.com> <5429971F.9050405@hp.com> <20140929180959.GG3879@kernel.org>
In-Reply-To: <20140929180959.GG3879@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 02:09 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 29, 2014 at 01:30:07PM -0400, Waiman Long escreveu:
>> On 09/28/2014 11:54 PM, Namhyung Kim wrote:
>>> On Fri, 26 Sep 2014 11:06:25 -0300, Arnaldo Carvalho de Melo wrote:
>>>> Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
>>>>> This is a precursor patch to enable long name searching of DSOs
>>>>> using the rbtree. In this patch, a new dsos structure is created
>>>>> which contains only a list head structure for the moment. The new
>>>>> dsos structure is used, in turn, in the machine structure for the
>>>>> user_dsos and kernel_dsos fields. Only the following 3 dsos functions
>>>>> are modified to accept the new dsos structure parameter instead
>>>>> of list_head:
>>>>>   - dsos__add()
>>>>>   - dsos__find()
>>>>>   - __dsos__findnew()
>>>>>
>>>>> Because of the need to find out the corresponding dsos structure to
>>>>> properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
>>>>> a new dsos field is also added to the dso structure.
>>>> Argh, yeah, that is unfortunate that we need to add entries that deep
>>>> inside dso__load_syms() :-\
>>> But it seems we can use map->groups->machine to find out the head/root
>>> of the dsos..
>> There are 2 dsos at the machine structure level - user_dsos and kernel_dsos.
>> In this particular case, it should be kernel_dsos. I can remove the dsos
>> pointer and hardcode it to use the kernel_dsos if you guys think it is
>> acceptable.
> Yes, I think that if we have already how to obtain the head/root where
> we want to insert things from structures present at that point in the
> code, no need to add it to the per-dso data structure.
>
> Thanks to Namhyung for finding an existing way of getting to the needed
> data structures.
>
> - Arnaldo

Sure, I will send out a new patch which includes the suggested change.

Thanks for the review.

-Longman
