Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaBZQMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:12:07 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56497 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaBZQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:12:04 -0500
Message-ID: <530E1247.7020604@linux.vnet.ibm.com>
Date: Wed, 26 Feb 2014 21:41:51 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [RFC PATCH v1 0/2] perf: Support for SDT markers
References: <20140224090833.7998.5416.stgit@hemant-fedora> <530C821D.7000704@hitachi.com> <530CBD53.9010605@linux.vnet.ibm.com> <87ha7muw14.fsf@sejong.aot.lge.com> <530DADEB.4090709@linux.vnet.ibm.com> <530DB6FE.9020307@hitachi.com>
In-Reply-To: <530DB6FE.9020307@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022616-1396-0000-0000-0000045B75E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 03:12 PM, Masami Hiramatsu wrote:
> (2014/02/26 18:03), Hemant Kumar wrote:
>> On 02/26/2014 01:48 PM, Namhyung Kim wrote:
>>> Hi Masami and Hemant,
>>>
>>> On Tue, 25 Feb 2014 21:27:07 +0530, Hemant Kumar wrote:
>>>> On 02/25/2014 05:14 PM, Masami Hiramatsu wrote:
>>>>> (2014/02/24 18:14), Hemant Kumar wrote:
>>>>>> First, scan the binaries using :
>>>>>> # perf list sdt --scan
>>>>>>
>>>>>> Creating a cache of SDT markers...
>>>>>> perf sdt cache created!
>>>>>>     Use : "perf list sdt"
>>>>>>     to see the SDT markers
>>>>> Hmm, in that case, I think you'd better introduce perf-sdt for scanning.
>>>>> e.g.
>>>>>
>>>>>     # perf sdt --scan app
>>>> Hmm, this seems a better idea :)
>>>>
>>>>>     then you can add app to sdt cache, without app,
>>>>>
>>>>>     # perf sdt --scan
>>>>>
>>>>>     will just scans all binaries on the PATH and the libraries which listed
>>>>> by `ldconfig --print-caceh`
>>> What should be done with the new perf sdt command?  If it's only
>>> intended to list the markers, I'd just suggest to add "perf list sdt" as
>>> this patch did.
> No, here what I said is, the "perf sdt" is only for managing SDT cache
> as like as "perf buildid-cache". Thus, "perf sdt-cache" might be better.

Ah! ok.

> BTW, the SDT markers can be changed if the application is updated.
> To ensure the correctness of SDT markers, we should store buildid in the
> cache file and check it when listing and using them.

Yeah! That's why perf list sdt --scan is storing the buildid too in the 
cache file.

>> If we display the SDT markers along with the other events in perf list,
>> then I think we can go with
>> perf list sdt. I am not too sure though! :)
>>
>> For me, the main issue was that the markers are not events. They become
>> events after
>> we place them in the uprobe_events file just like functions.  But we use
>> `perf list` to
>> display all the "events" available on a system. Isn't it?
> As I said, if perf accepts -e "%app:sdt" option, showing SDT events as
> fixed events does not matter, since it is transparent to users. :)
>
> Thank you,
>

Alright. Got it! :)

-- 
Thanks
Hemant Kumar

