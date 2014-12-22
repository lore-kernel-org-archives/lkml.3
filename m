Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaLVSMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:12:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaLVSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:12:28 -0500
Message-ID: <54985F05.2040603@oracle.com>
Date: Mon, 22 Dec 2014 13:12:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "davej @mail.xmission.com>> Dave Jones" <davej@redhat.com>
Subject: Re: fs: proc: gpf in find_entry
References: <54982C98.9070806@oracle.com>	<CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>	<87oaqvd6ni.fsf@x220.int.ebiederm.org> <CAPAsAGwRL-fg10cPYREbXmsk09EU4qVz-3AX+OkR-QifmOW2kQ@mail.gmail.com>
In-Reply-To: <CAPAsAGwRL-fg10cPYREbXmsk09EU4qVz-3AX+OkR-QifmOW2kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 12:52 PM, Andrey Ryabinin wrote:
> 2014-12-22 18:51 GMT+03:00 Eric W. Biederman <ebiederm@xmission.com>:
>> These two instructions:
>>>>   11:   4d 85 ff                test   %r15,%r15
>>>>   14:   0f 84 de 01 00 00       je     0x1f8
>>
>> Should prevent a NULL %r15 value from ever reaching the trapping
>> instruction.
> 
> If they were executed, then yes. But I think there was jump from somewhere
> to the instructions below those two.

There is indeed a jump direct to that point, which avoids the %r15 check.

>> What other horrible things does KASAN do to the machine code?
>>
> 
> kasan insert something like following before any memory access:
> 
> s8 *shadow_addr = (add >> 3) + shadow_offset;
> 
> if (unlikely(*shadow_addr))
>      if (unlikely(addr & 7 >= *shadow_addr))
>            report_bug(addr);
> 
> 
> I suspect that Sasha is using kasan along with ubsan.
> In that case generated code much more horrid.

It's not *that* bad :)


Thanks,
Sasha
