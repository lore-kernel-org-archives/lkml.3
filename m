Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaINRI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:08:28 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57724 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaINRI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:08:27 -0400
Message-ID: <5415CB86.8010209@cloudius-systems.com>
Date: Sun, 14 Sep 2014 20:08:22 +0300
From: Avi Kivity <avi@cloudius-systems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: [BUG] perf tools: Demangle kernel and kernel module symbols too
References: <20140906184631.GA6059@krava.brq.redhat.com> <5413BB4D.10606@cloudius-systems.com> <20140914094112.GT346@worktop.programming.kicks-ass.net>
In-Reply-To: <20140914094112.GT346@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/14/2014 12:41 PM, Peter Zijlstra wrote:
> On Sat, Sep 13, 2014 at 06:34:37AM +0300, Avi Kivity wrote:
>
>> It's not a simple matter of updating the test: the demangler interprets name
>> beginning with __vt as C++ mangles names, which of course they aren't.
> Oh, that'll give cute 'problems' in a mixed C/C++ project that just
> happens to have __vt names in. Now of course I'm aware that C/C++
> 'reserve' the __ prefix, which I suppose that makes it less likely in
> practise.

If you have clashes there, perf demangling is the least of your worries.

>> The only way I see to proceed is to make the demangling optional, default
>> off.
> Seems like a good way out, we could think about adding a language
> heuristic that tries and guess the target language and auto enables when
> it guesses C++, but that needs to have overrides as well.

It should be easy to look for common C++ mangled name
prefixes and use that as a guess, but I expect that users
who profile C++ guest kernels (or kernel modules) are
capable of adding the switch themselves.
