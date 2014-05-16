Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbaEPQCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:02:45 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43996 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaEPQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140516155958.GX11096@twins.programming.kicks-ass.net>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
	<1399999697-65875-7-git-send-email-dzickus@redhat.com>
	<CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
	<20140516155958.GX11096@twins.programming.kicks-ass.net>
Date: Fri, 16 May 2014 18:02:43 +0200
Message-ID: <CABPqkBS+jx6sR3BNjwGkaG9hZFtfwmLKKiD86Li4hAY_YsTDdA@mail.gmail.com>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 16, 2014 at 04:09:59PM +0200, Stephane Eranian wrote:
>> > +#define CACHE_LINESIZE       64
>> I had something similar to your patch here in my original series for
>> perf mem, but I never pushed it.
>> I think this is a useful feature to have.
>> However, I don't think you can hardcode the cache line size to 64.
>> This is generic
>> code. There may be architectures where the line size is different from 64.
>> So I think you should add an option to change the default line size or provide
>> an arch-specific definition.
>
> # cat /sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
> 64
Excellent, then we should use that!
