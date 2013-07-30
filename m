Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3G3QJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:09:17 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:55355 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3QJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130730155212.GB32226@laptop.programming.kicks-ass.net>
References: <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
	<CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
	<20130708081919.GV23916@twins.programming.kicks-ass.net>
	<CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
	<20130730083758.GH3008@twins.programming.kicks-ass.net>
	<CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com>
	<20130730090202.GL3008@twins.programming.kicks-ass.net>
	<CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com>
	<CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
	<20130730155212.GB32226@laptop.programming.kicks-ass.net>
Date: Tue, 30 Jul 2013 18:09:15 +0200
Message-ID: <CABPqkBQFpJjHLYuErcMdxTNKe4-JW_JZfYkEWrX5JHTZmWOqDg@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 30, 2013 at 04:21:41PM +0200, Stephane Eranian wrote:
>> Peter,
>>
>> One thing that bothers me with the MMAP2 approach is that
>> it forces integration into perf.
>
> This is a good (TM) thing, yes? ;-)
>

Well, that's one way to look at it. But I'd like the API to
be able to support more than one tool easily. If the barrier
for any advanced analysis is too high from the raw kernel
API then we will only have one tool. I don't think that sane.


>> Now, you will need to analyze
>> the MMAP2 records. With my sample_type approach, you
>> simply needed a cmdline option on perf record, and then
>> you could dump the sample using perf report -D and feed
>> them into a post-processing script. But now, the analysis
>> needs to be integrated into perf or the tool needs to parse
>> the full perf.data file.
>
> So the disadvantage of the sample_type approach is that it generates
> more data and bloats the fast path.
>
> If its useful it shouldn't live in a script anyway ;-) Also if the
> script muck can't deal with the side-band information its a worse broken
> piece of crap than I thought it was.

I never use the scripting support. Don't know its current shape.
