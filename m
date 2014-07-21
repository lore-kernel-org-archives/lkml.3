Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaGUVPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:15:04 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:48367 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaGUVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140719004941.GI18735@two.firstfloor.org>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
	<1405123285-23544-2-git-send-email-andi@firstfloor.org>
	<CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
	<20140714192451.GC5803@tassilo.jf.intel.com>
	<CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
	<20140714223918.GE5803@tassilo.jf.intel.com>
	<CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
	<20140719004941.GI18735@two.firstfloor.org>
Date: Mon, 21 Jul 2014 23:15:01 +0200
Message-ID: <CABPqkBQvtZ0Joc6nZOVp4Pt0Bh4=m8gw+_sVbdY9qMYD55YQOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 2:49 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Tue, Jul 15, 2014 at 12:49:43AM +0200, Stephane Eranian wrote:
>> On Tue, Jul 15, 2014 at 12:39 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> >> I have a problem with this patch.
>> >>
>> >> It makes: perf mem -t store rec record OP_NA for the store.
>> >> It was recording OP_STORE before.
>> >>
>> >> I think we need to keep LD/ST info. This is useful for analysis
>> >> especially if we collect loads/stores simultaneously.
>> >>
>> >> Was working before for the mem-loads, mem-stores events.
>> >
>> > Ok. Would it be enough if it only worked for "mem-stores" and not
>> > all PEBS events?
>> >
>> Ok, do that at a minimum.
>
> I fixed it now. However it turned out that "perf mem report"
> actually not report mem_op, only mem_lvl.
>
> You may want to fix that separately.
>
It is because it currently record loads or store but not both simultaneously.
Once I allow load/store in a single run, it will print the mem_op.

> -Andi
