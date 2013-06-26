Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3FZVBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:01:05 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63528 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3FZVBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:01:04 -0400
Message-ID: <51CB568B.4030605@gmail.com>
Date: Wed, 26 Jun 2013 15:00:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <51CB53A9.80004@gmail.com> <CABPqkBR=5TxFX=3J=p7EAPcbwK7E93rM1X4GKGsuw0Eopcf+6Q@mail.gmail.com>
In-Reply-To: <CABPqkBR=5TxFX=3J=p7EAPcbwK7E93rM1X4GKGsuw0Eopcf+6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 2:54 PM, Stephane Eranian wrote:
> On Wed, Jun 26, 2013 at 10:48 PM, David Ahern <dsahern@gmail.com> wrote:
>> Arnaldo:
>>
>> I noticed this patch in your perf/core branch. I do not think this one is
>> ready to be committed. It does not fully solve the problem of allowing
>> non-matching sample types.
>>
>> I have a set of patches here on github that work fine for one use case --
>> mixed s/w and tracepoint events:
>> https://github.com/dsahern/linux/tree/multiple-sample_type
>>
>> I'll push the patches out, but wanted to run some more test cases first.
>>
> All those solutions address the need of perf but they do not fix the fundamental
> problem that the kernel is exporting a un-parseable file in case of different
> sample_type for each event. We need to fix the generic case so that other
> tools don't have to deal with this. I will post a patch which can solve this
> in the kernel and yet remain backward compatible. But I don't  have the
> perf portion of the patch, hoping somebody can help with developing it.

The patchset in the URL above attempts to find the id which correlates 
to the evsel which has the sample_type. It starts at the max index (IP, 
TID, TIME and ADDR all requested which means an index of 4 for the ID) 
and then works its way in (meaning one of the above is not requested).

Would be better for the event sample to put the id at the front or the 
sample_type at the front, but that ship has sailed. It would be nice to 
have a userspace option that works with existing kernels.

I'll take a look at your kernel change when you post it to see what I am 
overlooking here but the patches have worked fine for me so far.

David

