Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaDIAOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:14:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34943 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIAOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140408224926.GY32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
	<CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
	<20140408224926.GY32556@tassilo.jf.intel.com>
Date: Tue, 8 Apr 2014 17:14:50 -0700
Message-ID: <CA+bK7J6i4G1DH372Cw+uuG6oogJEvY--cPJsohb+KqqyALbOEg@mail.gmail.com>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
From: Tim Bird <tbird20d@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hubicka@ucw.cz, jmario@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I'd really like to see this go in as an experimental feature.

Andi has already quoted my size results, which I thought were pretty
good, as well as given a pointer to my size optimization presentation.

Some of what follows is in the presentation, but here is a summary:
There are other automated reductions that I experimented with, that
are made more effective (or are only possible) with LTO.  Examples of
these include:
 - elimination of unused kernel command line handlers,
 - automated elimination of unused syscalls (through whole-system analysis), and
 - an experimental system I developed for doing structure reduction.

LTO shows promise for allowing more automation in configuration
handling (that is, requiring less CONFIG options).

People should definitely be warned off using this in any production
setting, but I think it's valuable for developers experimenting with
tiny-size systems to have this easily available in mainline.

On Tue, Apr 8, 2014 at 3:49 PM, Andi Kleen <ak@linux.intel.com> wrote:
> Hi Linus,
>
>> So right now, I see several reasons not to merge it ("It's so
>> experimental that we don't even want to encourage people to test it"
>
> I don't want them to enable it during allyesconfig because they
> might need more than 4GB of RAM to build it (especially with gcc
> 4.8, 4.9 is better). But allyesconfig is a special case. More standard
> kernels with smaller vmlinux don't have this problem, but build
> somewhat slower.
>
>> to "it's not fully fleshed out yet and makes compile times _much_
>> longer").
>
> It's functionally stable, I have a number of users who
> don't report any problems.
>
>>
>> And yet nobody has actually talked about why I *should* merge it.
>>
>> Which - I think understandably - makes me less than enthusiastic.
>>
>> So I think I'll let this wait a bit longer, _unless_ people start
>> talking about the upsides. How much smaller is the end result? How
>> much faster is it? How much more beautiful is it? Does it make new
>
> The smaller part is mainly visible with small kernels, because
> it's very good at throwing out unused code there.  All the
> stuff in kernel etc. that is not used.
>
> For example Tim Bird saw ~11% binary reduction on ARM with his
> configs [1]. We also see some reduction in small configs.
>
> Some of the static measures like nice, for example
> a LTO kernel has ~4% less calls.
>
> We did some performance tests, but at least in the standard
> macro benchmarks we do there wasn't a clear performance
> win.  LKP had a small win, but nothing dramatic.
> But I would like others to test it on their workloads.
>
> In principle LTO can do cool optimizations, like propagating
> constants into functions (e.g. generate specialized versions
> of some code). I experimented a bit with this, however
> it currently seems to bloat the code quite a bit.
>
> There are some other possible future optimizations
> that can be enabled by a global optimizer.
>
> Honza may have more reasons for LTO.
>
> Other benefits are global warnings and some additional
> type checking. The LTO log files are really useful
> to do global call graph analysis and similar.
>
> -Andi
>
> [1] http://elinux.org/images/9/9e/Bird-Kernel-Size-Optimization-LCJ-2013.pdf
>
> --
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
