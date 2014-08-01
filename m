Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaHAFnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:43:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:35682 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaHAFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:43:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf tools: Question about kmem and kernel symbol resolution
References: <CAM9d7ci1grg4NSMJahr-zjo+v8CkumbnwREhjkc+o6y9kYuaGw@mail.gmail.com>
	<20140731142711.GX7831@kernel.org>
Date: Fri, 01 Aug 2014 14:43:48 +0900
In-Reply-To: <20140731142711.GX7831@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 31 Jul 2014 11:27:11 -0300")
Message-ID: <878un8hii3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 11:27:11 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 31, 2014 at 05:35:32PM +0900, Namhyung Kim escreveu:
>> I'm looking kernel symbol mismatch issue, and found something in perf
>> kmem code.  The commit e727ca73f85d ("perf kmem: Resolve kernel
>> symbols again") added perf_session__create_kernel_maps() but I don't
>> know why.  Why did it miss the MMAP event?
>  
>> I think if we create a kernel maps at report time, it might not match
>> to samples in a perf.data if it's recorded on a different kernel.
>> This is the main reason of the mismatch problem I'm currently chasing
>> IMHO.  What am I missing?
>
>> From a quick look, nothing, i.e. we can not call
> perf_session__create_kernel_maps() at that point, as it will create the
> kernel maps from the running kernel and use it with events from the
> kernel that was in place when the perf.data file being processed was
> created.
>
> Perhaps that problem was fixed somewhere else and we should just revert
> that patch?
>
> Have you tried just reverting it and checking that the results are the
> expected ones? I.e. that there is the kernel MMAP event in perf.data
> file and that it gets properly processed?

Simply reverting ended up with no symbols but it contains MMAP event for
sure.

Then I found a reason - it's simply because kmem tools doesn't register
mmap event handlers. :-/  Adding mmap[2] handlers + reverting ended up
with the expected output.

I'll send the fix soon.

Thanks,
Namhyung
