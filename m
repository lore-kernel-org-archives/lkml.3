Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3G3O7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:59:07 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38211 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3G3O7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:59:05 -0400
Message-ID: <51F7D4B5.7020300@gmail.com>
Date: Tue, 30 Jul 2013 08:59:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
References: <20130625104700.GZ28407@twins.programming.kicks-ass.net> <20130625105123.GA13649@gmail.com> <20130626103303.GB28407@twins.programming.kicks-ass.net> <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com> <20130628095828.GG29209@dyad.programming.kicks-ass.net> <CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com> <20130708081919.GV23916@twins.programming.kicks-ass.net> <CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com> <20130730083758.GH3008@twins.programming.kicks-ass.net> <CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com> <20130730090202.GL3008@twins.programming.kicks-ass.net> <CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com> <CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com> <51F7D2A9.7030803@gmail.com> <CABPqkBQUKceC3dFTDZf5L=vifWQrdNPie9wxh4axGLXA9wXoHQ@mail.gmail.com>
In-Reply-To: <CABPqkBQUKceC3dFTDZf5L=vifWQrdNPie9wxh4axGLXA9wXoHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/13 8:53 AM, Stephane Eranian wrote:
> On Tue, Jul 30, 2013 at 4:50 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 7/30/13 8:21 AM, Stephane Eranian wrote:
>>>
>>> One thing that bothers me with the MMAP2 approach is that
>>> it forces integration into perf. Now, you will need to analyze
>>> the MMAP2 records. With my sample_type approach, you
>>> simply needed a cmdline option on perf record, and then
>>> you could dump the sample using perf report -D and feed
>>
>>
>> what do you want that is not coming out via perf-script?
>>
> mmap records. Are they passed to scripts?

I don't do much with external scripts, but I do not believe they are 
passed. I use 'perf script -f <opts>' a lot to see the individual 
samples (e.g., tracepoints and software events).

It could easily be adapted to dump mmap events, but does not sound like 
it improves your workload.

David
