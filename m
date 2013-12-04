Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3LDQzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:55:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab3LDQzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:55:51 -0500
Message-ID: <529F5E47.3040108@zytor.com>
Date: Wed, 04 Dec 2013 08:54:31 -0800
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
References: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com> <20131204111125.GA26552@redhat.com> <529F51D9.7010001@zytor.com> <20131204164817.GA5271@redhat.com>
In-Reply-To: <20131204164817.GA5271@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 08:48 AM, Oleg Nesterov wrote:
> On 12/04, H. Peter Anvin wrote:
>>
>> On 12/04/2013 03:11 AM, Oleg Nesterov wrote:
>>>
>>> It is still not clear to me if we can simply change a single byte on
>>> x86 or not, but at least on powerpc we need to update 4 bytes. Perhaps
>>> we can conditionalize these pte games later.
>>>
>>
>> But 4 aligned bytes can be written as a single transaction.
> 
> Ah yes, this is true.
> 

That is why I talk about the atomic instruction word... most (but not
*all*) architectures have a fundamental minimum unit of instructions
which is aligned and can be atomically written.  Typically this is 1, 2,
or 4 bytes.

	-hpa

