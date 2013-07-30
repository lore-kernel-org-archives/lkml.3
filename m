Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3G3OxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:53:20 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:51034 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3G3OxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <51F7D2A9.7030803@gmail.com>
References: <20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
	<CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
	<CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
	<20130708081919.GV23916@twins.programming.kicks-ass.net>
	<CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
	<20130730083758.GH3008@twins.programming.kicks-ass.net>
	<CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com>
	<20130730090202.GL3008@twins.programming.kicks-ass.net>
	<CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com>
	<CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
	<51F7D2A9.7030803@gmail.com>
Date: Tue, 30 Jul 2013 16:53:17 +0200
Message-ID: <CABPqkBQUKceC3dFTDZf5L=vifWQrdNPie9wxh4axGLXA9wXoHQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 4:50 PM, David Ahern <dsahern@gmail.com> wrote:
> On 7/30/13 8:21 AM, Stephane Eranian wrote:
>>
>> One thing that bothers me with the MMAP2 approach is that
>> it forces integration into perf. Now, you will need to analyze
>> the MMAP2 records. With my sample_type approach, you
>> simply needed a cmdline option on perf record, and then
>> you could dump the sample using perf report -D and feed
>
>
> what do you want that is not coming out via perf-script?
>
mmap records. Are they passed to scripts?

>
>> them into a post-processing script. But now, the analysis
>> needs to be integrated into perf or the tool needs to parse
>> the full perf.data file.
>
>
> you mean parsed during perf-record?
>
No, I mean for a standalone tool on top of perf record.
With my approach, you can simply write a wrapper script
around perf report and do the analysis.
