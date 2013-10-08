Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3JHT5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:57:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43993 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3JHT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:57:48 -0400
Message-ID: <525463B7.3030203@gmail.com>
Date: Tue, 08 Oct 2013 13:57:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com> <52541556.5060907@gmail.com> <20131008194129.GC7315@gmail.com> <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
In-Reply-To: <CABPqkBTibSKs9qG_RARn2+vrHb6VODN9N9BPGSv_MAQEXZcGmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 1:54 PM, Stephane Eranian wrote:
>>> If the current MMAP2 is not a complete solution for what you (Google)
>>> need, should support be reverted before 3.12 is released? No sense in
>>> making this part of the forever API if more work is needed on it.
>>
>> Instead of a full revert we could just turn off the ABI portion minimally
>> and not recognize it for now. Assuming a more complete solution is in the
>> works for v3.13.
>>
> That's a possibility. They are also pieces in the perf tool itself.
> We could certainly make the attr->mmap2 bit disappear.
>
> I think it boils down to how can we uniquely identify virtual
> mapping to the same physical data either via shmat(), files, VM_CLONE.
> We had all covered but the last case with the ino approach. We don't have
> a solution for VM_CLONE yet.
>

I was mainly thinking the 2 parts that generate MMAP2 events: kernel 
side it's the mmap2 attribute and perf_event_mmap_output; userspace side 
it's perf_event__synthesize_mmap_event. Certainly the rest of the 
plumbing can be left in place until the solution is refined as needed.

David

