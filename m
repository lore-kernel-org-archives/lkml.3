Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3JIQjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:39:07 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:45489 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3JIQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
References: <20131009161743.GA3022@quad>
	<52558278.6080206@gmail.com>
	<CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
Date: Wed, 9 Oct 2013 18:39:02 +0200
Message-ID: <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
Subject: Re: [PATCH] perf: disable mmap2 support
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 6:24 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Oct 9, 2013 at 6:21 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 10/9/13 10:17 AM, Stephane Eranian wrote:
>>>
>>>
>>> This patch disables the mmap2 record format support
>>> for now. The support needs a bit more work to cover
>>> VM_CLONE cases.
>>>
>>> The patch leaves attr->mmap2 defined, but returns
>>> an error if it is set. That ensures no PERF_RECORD_MMAP2
>>> record can be generated. Yet it minimizes the reverts in
>>> the perf tool.
>>
>>
>> The userspace code generates MMAP2 events for synthesized mmap events. That
>> should be reverted to MMAP until the format of MMAP2 events is finalized.
>>
> Ah, yes, that is correct. I forgot about that ;-(
> Let me send a revised patch then that covers both.
>
Looks like the easiest thing to do for perf is to revert:

   Revert "perf tools: Add default handler for mmap2 events"
   git revert 6adb0b0ae26fcc35cfec068d71f13863faac5b44

   Revert "perf tools: Add attr->mmap2 support"
   git revert 5c5e854bc760a2e2c878df3cfcf2afa4febcd511

Do you agree?
