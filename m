Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaFZUNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:13:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33171 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaFZUNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:13:18 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrWJD4kvoCxxb9y19uMakChmxamveKDceDOhyjYzFkJoUA@mail.gmail.com>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net> <20140626195629.GC5714@two.firstfloor.org> <CALCETrVBKno2skh3zR=1GYuojwPhYPLD=1HFcLMXjStS+0SPJQ@mail.gmail.com> <CALCETrWJD4kvoCxxb9y19uMakChmxamveKDceDOhyjYzFkJoUA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 26 Jun 2014 13:12:35 -0700
To: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>
CC: X86 ML <x86@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Message-ID: <7919ae8b-958b-4b12-a5f4-8be2c3df3824@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real question is if we care that sysret and iter don't match.  On 32 bits the situation is even more complex.

On June 26, 2014 1:00:22 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Thu, Jun 26, 2014 at 12:59 PM, Andy Lutomirski <luto@amacapital.net>
>wrote:
>> On Thu, Jun 26, 2014 at 12:56 PM, Andi Kleen <andi@firstfloor.org>
>wrote:
>>>> show RCX == RIP even under strace.
>>>
>>> If you think it's really worth the extra instruction?
>>
>> Hard to say.  That extra instruction only happens on slow paths, so I
>> suspect the slowdown is negligible.  On the other hand, having
>syscall
>> show a blatant difference in behavior between traced and untraced
>> processes seems unfortunate.
>>
>>>
>>> It's not wrong, but it's not clear if it's useful.
>
>Also, if anyone ever wants to add some code to switch back from iret
>to sysret when sysret will work, this is a prerequisite.  Otherwise
>sysret will never match iret.  (I'm not immediately planning on doing
>this, but I can imagine workloads (e.g. UML) for which it would be a
>big improvement.)
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
