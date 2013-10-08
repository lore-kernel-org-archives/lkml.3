Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3JHOXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:23:25 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53651 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3JHOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:23:24 -0400
Message-ID: <52541556.5060907@gmail.com>
Date: Tue, 08 Oct 2013 08:23:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
In-Reply-To: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane:

On 9/30/13 9:44 AM, Stephane Eranian wrote:
> I was alerted by people trying to use the PERF_RECORD_MMAP2
> record to disambiguate virtual address mappings that there is a case
> where the record does not contain enough information.
>
> As you know, the MMAP2 record adds the major, minor, ino number,
> inode generation numbers to a mapping. But it does that only for
> file or pseudo -file backed mappings. That covers file mmaps and also
> SYSV shared memory segments.
>
> However there is a another kind of situation that arises in some
> multi-process benchmarks where a region of memory is cloned
> using VM_CLONE. As such, the virtual addresses match between
> the processes but the major, minor, inode, inode generation  fields
> are all zeroes because there is no inode associated with the mapping.
> Yet, it is important for the tool to know the mappings between the
> processes are pointing to the same physical data.
>
> We need to cover this case and I am seeking for advice on how to
> best address this need given that we discarded using the plain physical
> address for disambiguation.


If the current MMAP2 is not a complete solution for what you (Google) 
need, should support be reverted before 3.12 is released? No sense in 
making this part of the forever API if more work is needed on it.

David
