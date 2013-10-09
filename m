Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JIQYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:24:41 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45676 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3JIQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <52558278.6080206@gmail.com>
References: <20131009161743.GA3022@quad>
	<52558278.6080206@gmail.com>
Date: Wed, 9 Oct 2013 18:24:39 +0200
Message-ID: <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
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

On Wed, Oct 9, 2013 at 6:21 PM, David Ahern <dsahern@gmail.com> wrote:
> On 10/9/13 10:17 AM, Stephane Eranian wrote:
>>
>>
>> This patch disables the mmap2 record format support
>> for now. The support needs a bit more work to cover
>> VM_CLONE cases.
>>
>> The patch leaves attr->mmap2 defined, but returns
>> an error if it is set. That ensures no PERF_RECORD_MMAP2
>> record can be generated. Yet it minimizes the reverts in
>> the perf tool.
>
>
> The userspace code generates MMAP2 events for synthesized mmap events. That
> should be reverted to MMAP until the format of MMAP2 events is finalized.
>
Ah, yes, that is correct. I forgot about that ;-(
Let me send a revised patch then that covers both.

> David
