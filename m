Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbaBWGIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:08:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47050 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaBWGIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:08:47 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu> <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: perf_fuzzer compiled for x32 causes reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 22 Feb 2014 22:07:50 -0800
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Message-ID: <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd be interested in how rbp gets set, too.  It might just be a coincidence and the value in rbp has some other meaning here.

On February 22, 2014 9:18:17 PM PST, Vince Weaver <vincent.weaver@maine.edu> wrote:
>On Fri, 21 Feb 2014, H. Peter Anvin wrote:
>
>> Error 6 reflects a write in userspace to a not-present page.
>> 
>> Since your previous trace indicates that the value of the register in
>question
>> is a different one, I'm guessing that what we have here is PEBS
>getting
>> activated.  0x120 is 2*0x90, and 0x90 is the size of a 64-bit PEBS
>record.
>
>I'm having problems generating a replayable syscall trace that exhibits
>
>the problem.
>
>It turns out that the segfault address listed (the multiple of 0x120) 
>happens to be the value in the RBP register at the time of the
>segfault.
>
>That's odd, as the instruction is
>	movdqa %xmm0,(%rdi)
>and rdi is the valid mmap address of the perf ring buffer
>	rdi            0xf7768000	4151738368
>
>so I'm not sure why RBP is involved at all.
>
>In all of the cases I've investigated the precise_ip value has been set
>
>for the problem event... but none of the events have been hardware
>events
>(software and breakpoint so far).  So probably not PEBS related?
>
>Vince

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
