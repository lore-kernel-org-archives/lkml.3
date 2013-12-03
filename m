Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LCUog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:44:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47793 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab3LCUof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:44:35 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131203203826.GA24812@redhat.com>
References: <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the	page directly
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 03 Dec 2013 12:43:05 -0800
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Message-ID: <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no architecture-independent way to make code globally visible.

Oleg Nesterov <oleg@redhat.com> wrote:
>On 12/03, H. Peter Anvin wrote:
>>
>> On 12/03/2013 12:01 PM, Oleg Nesterov wrote:
>> >
>> >> followed by whatever synchronization necessary to make it globally
>visible.
>> >
>> > Could you explain what this synchronization should actually do ?
>> >
>>
>> That is architecture-dependent. On x86 it requires each CPU on which
>> this code is visible to be IPId, on others it involves complex icache
>> flushing protocols.
>
>Hmm. And why this would be better than arch-independent code I sent?
>
>IOW. Could you please comment the patch I sent?
>
>Oleg.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
