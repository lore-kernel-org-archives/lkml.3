Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3FZVH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:07:56 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47332 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3FZVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:07:55 -0400
MIME-Version: 1.0
In-Reply-To: <51CB568B.4030605@gmail.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
	<1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
	<51CB53A9.80004@gmail.com>
	<CABPqkBR=5TxFX=3J=p7EAPcbwK7E93rM1X4GKGsuw0Eopcf+6Q@mail.gmail.com>
	<51CB568B.4030605@gmail.com>
Date: Wed, 26 Jun 2013 23:07:54 +0200
Message-ID: <CABPqkBRBqXQK8Dz8uHt09Y-L8eGT3ou6e8uwBwS9wdDu=7c0gQ@mail.gmail.com>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:00 PM, David Ahern <dsahern@gmail.com> wrote:
> On 6/26/13 2:54 PM, Stephane Eranian wrote:
>>
>> On Wed, Jun 26, 2013 at 10:48 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> Arnaldo:
>>>
>>> I noticed this patch in your perf/core branch. I do not think this one is
>>> ready to be committed. It does not fully solve the problem of allowing
>>> non-matching sample types.
>>>
>>> I have a set of patches here on github that work fine for one use case --
>>> mixed s/w and tracepoint events:
>>> https://github.com/dsahern/linux/tree/multiple-sample_type
>>>
>>> I'll push the patches out, but wanted to run some more test cases first.
>>>
>> All those solutions address the need of perf but they do not fix the
>> fundamental
>> problem that the kernel is exporting a un-parseable file in case of
>> different
>> sample_type for each event. We need to fix the generic case so that other
>> tools don't have to deal with this. I will post a patch which can solve
>> this
>> in the kernel and yet remain backward compatible. But I don't  have the
>> perf portion of the patch, hoping somebody can help with developing it.
>
>
> The patchset in the URL above attempts to find the id which correlates to
> the evsel which has the sample_type. It starts at the max index (IP, TID,
> TIME and ADDR all requested which means an index of 4 for the ID) and then
> works its way in (meaning one of the above is not requested).
>
But you realize that imposing this kind of iterative search on all the tools
is not very good. it probably solves it for perf and the way perf tracks
the  per-event info, but they ought to be something simpler to do.


> Would be better for the event sample to put the id at the front or the
> sample_type at the front, but that ship has sailed. It would be nice to have
> a userspace option that works with existing kernels.
>
> I'll take a look at your kernel change when you post it to see what I am
> overlooking here but the patches have worked fine for me so far.
>
> David
>
