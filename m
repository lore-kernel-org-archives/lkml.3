Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaEPQ1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:27:39 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39584 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbaEPQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140516162441.GA50500@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
	<1399999697-65875-7-git-send-email-dzickus@redhat.com>
	<CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
	<20140516155958.GX11096@twins.programming.kicks-ass.net>
	<CABPqkBS+jx6sR3BNjwGkaG9hZFtfwmLKKiD86Li4hAY_YsTDdA@mail.gmail.com>
	<20140516162441.GA50500@redhat.com>
Date: Fri, 16 May 2014 18:27:35 +0200
Message-ID: <CABPqkBT6wv7qdJAJGuqK=vmhOAq9P-bvAAKwb8M=fMCfsj=bwQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 6:24 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, May 16, 2014 at 06:02:43PM +0200, Stephane Eranian wrote:
>> On Fri, May 16, 2014 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, May 16, 2014 at 04:09:59PM +0200, Stephane Eranian wrote:
>> >> > +#define CACHE_LINESIZE       64
>> >> I had something similar to your patch here in my original series for
>> >> perf mem, but I never pushed it.
>> >> I think this is a useful feature to have.
>> >> However, I don't think you can hardcode the cache line size to 64.
>> >> This is generic
>> >> code. There may be architectures where the line size is different from 64.
>> >> So I think you should add an option to change the default line size or provide
>> >> an arch-specific definition.
>> >
>> > # cat /sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
>> > 64
>> Excellent, then we should use that!
>
> Would it make sense to create an accessory function that sets the size in
> util/cpumap.c and provides it as an inline from util/cpumap.h?
>
I am fine with it.
