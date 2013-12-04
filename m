Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3LDSji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:39:38 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59794 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab3LDSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131204090336.GA31973@gmail.com>
References: <20131204090028.GA9724@quad>
	<20131204090336.GA31973@gmail.com>
Date: Wed, 4 Dec 2013 19:39:33 +0100
Message-ID: <CABPqkBR4PWFB2z9xhMa9qiJxBXxV5kq8k93PdxWfdj-3EmGb9Q@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: fix bug in event constraint end marker macro
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Ok, I have asked Maria to clean the patch up add more comments and
repost a new version of the
patch. She will repost ASAP.

Thanks.

On Wed, Dec 4, 2013 at 10:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>>  #define EVENT_CONSTRAINT_END         \
>> -     EVENT_CONSTRAINT(0, 0, 0)
>> +     { .idxmsk64 = 0,                \
>> +       .code = 0,                    \
>> +       .cmask = 0,                   \
>> +       .weight = -1,                 \
>> +       .overlap = 0,                 \
>> +       .flags = 0,                   \
>> +}
>
> A nit, simply writing:
>
> #define EVENT_CONSTRAINT_END { .weight = -1, }
>
> ... should be enough as initialization to zero is guaranteed for the
> other fields.
>
> Thanks,
>
>         Ingo
