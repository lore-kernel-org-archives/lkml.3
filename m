Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBZJDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:03:53 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34981 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaBZJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:03:47 -0500
Message-ID: <530DADEB.4090709@linux.vnet.ibm.com>
Date: Wed, 26 Feb 2014 14:33:39 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [RFC PATCH v1 0/2] perf: Support for SDT markers
References: <20140224090833.7998.5416.stgit@hemant-fedora> <530C821D.7000704@hitachi.com> <530CBD53.9010605@linux.vnet.ibm.com> <87ha7muw14.fsf@sejong.aot.lge.com>
In-Reply-To: <87ha7muw14.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022609-8256-0000-0000-00000BA8579A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 01:48 PM, Namhyung Kim wrote:
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
>>>>    Use : "perf list sdt"
>>>>    to see the SDT markers
>>> Hmm, in that case, I think you'd better introduce perf-sdt for scanning.
>>> e.g.
>>>
>>>    # perf sdt --scan app
>> Hmm, this seems a better idea :)
>>
>>>    then you can add app to sdt cache, without app,
>>>
>>>    # perf sdt --scan
>>>
>>>    will just scans all binaries on the PATH and the libraries which listed
>>> by `ldconfig --print-caceh`
> What should be done with the new perf sdt command?  If it's only
> intended to list the markers, I'd just suggest to add "perf list sdt" as
> this patch did.

If we display the SDT markers along with the other events in perf list, 
then I think we can go with
perf list sdt. I am not too sure though! :)

For me, the main issue was that the markers are not events. They become 
events after
we place them in the uprobe_events file just like functions.  But we use 
`perf list` to
display all the "events" available on a system. Isn't it?

> Plus I think it'd be better if event_glob pattern also looks for sdt
> markers so that user can find out a specific markers easily, e.g.:
>
>    # perf list rtld:*
>
> or
>
>    # perf list %rtld:*

Good idea! Will surely include support for this in event_glob pattern.

>>> And perf-list shows only the SDTs in the cache.
>> Well, what will be better? perf-list or perf-sdt or perf-list sdt??
>> If perf-list, then wouldn't it be a huge list!!
> The output of perf list is already a huge list and we paginate it.  So I
> don't think it's gonna be a problem. :)

Ok! Then we can use perf list. :)

>
>>>> - Add support to probe these SDT markers and integrate with a previous patch
>>>>     (support to perf to probe SDT markers) posted in lkml.
>>>>     https://lkml.org/lkml/2013/10/23/10
>>> Yeah, but I think we'd better choose another way to integrate it.
>>> Since SDT is like markers(static events), setting each of them via perf-probe is
>>> not intuitive. :)  I'd like to use it as an event, e.g.
>>>
>>>    # perf top -e "%libgcc:unwind"
>>>
>>> And perf top internally calls perf-probe to add new uprobe event, and
>>> clean the new event at exit.
>> Yeah! Right :) Makes sense.
>>
>> Will implement the suggestions in the next version asap!
> That would be great!

-- 
Thanks
Hemant Kumar

