Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3LCWna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48855 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab3LCWn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:43:29 -0500
Message-ID: <529E5E3A.9070401@zytor.com>
Date: Tue, 03 Dec 2013 14:42:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
 page directly
References: <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com>
In-Reply-To: <20131203205400.GA25735@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 12:54 PM, Oleg Nesterov wrote:
> On 12/03, H. Peter Anvin wrote:
>>
>> There is no architecture-independent way to make code globally visible.
> 
> Then I probably misunderstood "globally". Or something else.
> 
> So do you think the patch I sent is wrong? Why?
> 

It is wrong in the sense that without an architecture-specific
synchronization at the end it is not guaranteed to work.  It will work
fine on x86 and presumably any other architecture where icache-dcache
coherency is enforced in hardware (I am *guessing* that includes all or
most SMP platforms, but it is definitely *not* true on all UP platforms.)

	-hpa


