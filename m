Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaBZISf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:18:35 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61103 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaBZISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:18:33 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-d6-530da357a251
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [RFC PATCH v1 0/2] perf: Support for SDT markers
References: <20140224090833.7998.5416.stgit@hemant-fedora>
	<530C821D.7000704@hitachi.com> <530CBD53.9010605@linux.vnet.ibm.com>
Date: Wed, 26 Feb 2014 17:18:31 +0900
In-Reply-To: <530CBD53.9010605@linux.vnet.ibm.com> (Hemant Kumar's message of
	"Tue, 25 Feb 2014 21:27:07 +0530")
Message-ID: <87ha7muw14.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami and Hemant,

On Tue, 25 Feb 2014 21:27:07 +0530, Hemant Kumar wrote:
> On 02/25/2014 05:14 PM, Masami Hiramatsu wrote:
>> (2014/02/24 18:14), Hemant Kumar wrote:
>>> First, scan the binaries using :
>>> # perf list sdt --scan
>>>
>>> Creating a cache of SDT markers...
>>> perf sdt cache created!
>>>   Use : "perf list sdt"
>>>   to see the SDT markers
>> Hmm, in that case, I think you'd better introduce perf-sdt for scanning.
>> e.g.
>>
>>   # perf sdt --scan app
>
> Hmm, this seems a better idea :)
>
>>   then you can add app to sdt cache, without app,
>>
>>   # perf sdt --scan
>>
>>   will just scans all binaries on the PATH and the libraries which listed
>> by `ldconfig --print-caceh`

What should be done with the new perf sdt command?  If it's only
intended to list the markers, I'd just suggest to add "perf list sdt" as
this patch did.

Plus I think it'd be better if event_glob pattern also looks for sdt
markers so that user can find out a specific markers easily, e.g.:

  # perf list rtld:*

or

  # perf list %rtld:*

>>
>> And perf-list shows only the SDTs in the cache.
>
> Well, what will be better? perf-list or perf-sdt or perf-list sdt??
> If perf-list, then wouldn't it be a huge list!!

The output of perf list is already a huge list and we paginate it.  So I
don't think it's gonna be a problem. :)


>>> - Add support to probe these SDT markers and integrate with a previous patch
>>>    (support to perf to probe SDT markers) posted in lkml.
>>>    https://lkml.org/lkml/2013/10/23/10
>> Yeah, but I think we'd better choose another way to integrate it.
>> Since SDT is like markers(static events), setting each of them via perf-probe is
>> not intuitive. :)  I'd like to use it as an event, e.g.
>>
>>   # perf top -e "%libgcc:unwind"
>>
>> And perf top internally calls perf-probe to add new uprobe event, and
>> clean the new event at exit.
>
> Yeah! Right :) Makes sense.
>
> Will implement the suggestions in the next version asap!

That would be great!

Thanks,
Namhyung
