Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3KENes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:34:48 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40176 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3KENer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131104145110.GA2805@krava.brq.redhat.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
	<1383231582-15856-3-git-send-email-eranian@google.com>
	<20131101105722.GA1088@krava.brq.redhat.com>
	<CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
	<20131104145110.GA2805@krava.brq.redhat.com>
Date: Tue, 5 Nov 2013 14:34:45 +0100
Message-ID: <CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One thing I realized while testing is that we cannot simply add the
unit printout like that.
This may break all the scripts people may have written to parse the
output of perf stat.
I think we need to make the display of the unit optional. If I do:
   $ perf stat -e cycles ls

The output should remain as it was before and not show:
$ perf stat -e cycles ls
      22782847475 ? cycles

So I think we need a --show-unit option. It would be off by default.
Of course doing this causes a mess with the current code because
of all the various printf() in builtin-stat.c but I think it is better for
the end user.

Any opinion?

On Mon, Nov 4, 2013 at 3:51 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Nov 04, 2013 at 03:47:53PM +0100, Stephane Eranian wrote:
>> Jiri,
>>
>>
>> Thanks for the patch. I tested it and it works fine.
>> I will merge it with my "unit and scale" and add
>> your Signed-off-by. Is that okay with you?
>
> sure, np
>
> jirka
