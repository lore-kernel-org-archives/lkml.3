Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaBZJWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:22:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50816 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBZJWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:22:10 -0500
Message-ID: <530DB23B.6050503@hitachi.com>
Date: Wed, 26 Feb 2014 18:22:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: Re: [RFC PATCH v1 0/2] perf: Support for SDT markers
References: <20140224090833.7998.5416.stgit@hemant-fedora> <530C821D.7000704@hitachi.com> <530CBD53.9010605@linux.vnet.ibm.com> <87ha7muw14.fsf@sejong.aot.lge.com>
In-Reply-To: <87ha7muw14.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/26 17:18), Namhyung Kim wrote:
> Hi Masami and Hemant,
> 
> On Tue, 25 Feb 2014 21:27:07 +0530, Hemant Kumar wrote:
>> On 02/25/2014 05:14 PM, Masami Hiramatsu wrote:
>>> (2014/02/24 18:14), Hemant Kumar wrote:
>>>> First, scan the binaries using :
>>>> # perf list sdt --scan
>>>>
>>>> Creating a cache of SDT markers...
>>>> perf sdt cache created!
>>>>   Use : "perf list sdt"
>>>>   to see the SDT markers
>>> Hmm, in that case, I think you'd better introduce perf-sdt for scanning.
>>> e.g.
>>>
>>>   # perf sdt --scan app
>>
>> Hmm, this seems a better idea :)
>>
>>>   then you can add app to sdt cache, without app,
>>>
>>>   # perf sdt --scan
>>>
>>>   will just scans all binaries on the PATH and the libraries which listed
>>> by `ldconfig --print-caceh`
> 
> What should be done with the new perf sdt command?  If it's only
> intended to list the markers, I'd just suggest to add "perf list sdt" as
> this patch did.
> 
> Plus I think it'd be better if event_glob pattern also looks for sdt
> markers so that user can find out a specific markers easily, e.g.:
> 
>   # perf list rtld:*
> 
> or
> 
>   # perf list %rtld:*

Ah, that's a good idea :)

>>>
>>> And perf-list shows only the SDTs in the cache.
>>
>> Well, what will be better? perf-list or perf-sdt or perf-list sdt??
>> If perf-list, then wouldn't it be a huge list!!
> 
> The output of perf list is already a huge list and we paginate it.  So I
> don't think it's gonna be a problem. :)

Agreed.

>>>> - Add support to probe these SDT markers and integrate with a previous patch
>>>>    (support to perf to probe SDT markers) posted in lkml.
>>>>    https://lkml.org/lkml/2013/10/23/10
>>> Yeah, but I think we'd better choose another way to integrate it.
>>> Since SDT is like markers(static events), setting each of them via perf-probe is
>>> not intuitive. :)  I'd like to use it as an event, e.g.
>>>
>>>   # perf top -e "%libgcc:unwind"
>>>
>>> And perf top internally calls perf-probe to add new uprobe event, and
>>> clean the new event at exit.
>>
>> Yeah! Right :) Makes sense.

Note that we will need an option to make it permanent (not clear the event on exit)
for people who want to use SDT event from ftrace. :)

>> Will implement the suggestions in the next version asap!
> 
> That would be great!

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


