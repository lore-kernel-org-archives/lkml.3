Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaBVFFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 00:05:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34733 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaBVFFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 00:05:00 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: perf_fuzzer compiled for x32 causes reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Feb 2014 21:03:38 -0800
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Message-ID: <9c6de222-14f4-4275-ad71-aa4c38d1c86a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are segfaults in user space, though?

On February 21, 2014 8:50:38 PM PST, Vince Weaver <vincent.weaver@maine.edu> wrote:
>
>So I changed the perf_fuzzer so when it randomly stomps all over the
>perf_event_mmap_page, it uses a constant value of 0xdeadbeef rather
>than a random value.
>
>The result is below.  The segfaults make a bit more sense now, it
>almost looks like what is happening is we are corrupting an address
>value somehow (head? tail?) and the kernel then uses the corrupt
>address 
>and writes to memory outside of the mmap ring buffer.
>
>I still haven't figured out how to trigger this exactly, but you can
>see when over-written with 0xdeadbeef the memory address written to is
>consistently some small multiple of 0x120.
>
>I imagine it would be a bad thing if it turned out to be possible to 
>select what memory address got written to.  Although since I've
>only reproduced this on x32 maybe it won't be possible to over-write
>the kernel; but I have seen this bug cause a reboot when the
>wrong thing got over-written.
>
>[28002.850192] perf_fuzzer[7083]: segfault at 2be0 ip 000000000041efab
>sp 00000000ff826748 error 6 in perf_fuzzer[400000+d1000]
>[28639.769869] perf_fuzzer[7100]: segfault at 1320 ip 000000000041efab
>sp 00000000ffa65038 error 6 in perf_fuzzer[400000+d1000]
>[29396.986242] perf_fuzzer[7120]: segfault at 10e0 ip 000000000041efab
>sp 00000000ffd48e68 error 6 in perf_fuzzer[400000+d1000]
>[29738.892931] perf_fuzzer[7128]: segfault at 18c0 ip 000000000041efab
>sp 00000000ffcdcd88 error 6 in perf_fuzzer[400000+d1000]
>[29815.550210] perf_fuzzer[7132]: segfault at 120 ip 000000000041efab
>sp 00000000ffe673b8 error 6 in perf_fuzzer[400000+d1000]
>[30173.455348] perf_fuzzer[7141]: segfault at 120 ip 000000000041efab
>sp 00000000ffda1948 error 6 in perf_fuzzer[400000+d1000]
>[30570.625642] perf_fuzzer[7156]: segfault at 1680 ip 000000000041efab
>sp 00000000ffaad028 error 6 in perf_fuzzer[400000+d1000]
>[31047.887784] perf_fuzzer[7169]: segfault at 60c0 ip 000000000041efab
>sp 00000000ffaa86e8 error 6 in perf_fuzzer[400000+d1000]
>[31300.168714] perf_fuzzer[7175]: segfault at 3a80 ip 000000000041efab
>sp 00000000ffd83228 error 6 in perf_fuzzer[400000+d1000]
>[31984.727278] perf_fuzzer[7193]: segfault at 7e0 ip 000000000041efab
>sp 00000000ff9db1f8 error 6 in perf_fuzzer[400000+d1000]
>
>Vince

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
