Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3BDFfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:35:43 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58379 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3BDFfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:35:41 -0500
MIME-Version: 1.0
X-Originating-IP: [50.196.179.26]
In-Reply-To: <20130204050550.GA4503@ZenIV.linux.org.uk>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
	<20130127195714.GA11224@samfundet.no>
	<20130127203009.GG4503@ZenIV.linux.org.uk>
	<20130127203954.GA22063@samfundet.no>
	<20130204001055.GV4503@ZenIV.linux.org.uk>
	<20130204003047.GW4503@ZenIV.linux.org.uk>
	<20130204013111.GX4503@ZenIV.linux.org.uk>
	<20130204030221.GY4503@ZenIV.linux.org.uk>
	<CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
	<20130204050550.GA4503@ZenIV.linux.org.uk>
Date: Sun, 3 Feb 2013 21:35:39 -0800
X-Google-Sender-Auth: Mcp12qNiv6DhtpTq7Frl9YrtI_M
Message-ID: <CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 9:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Feb 03, 2013 at 08:52:18PM -0800, H?vard Skinnemoen wrote:
>
>> You're right on -- in this case, the compiler will skip r10, and do
>> (r12, r11, r8:r9, stack). We pass the syscall number in r8, but we
>> also unconditionally move r7 to r8 in the syscall path, so it
>> shouldn't matter (libc does the opposite when necessary).
>>
>> I remember some talk about having the compiler reuse r10 for the next
>> 32-bit argument in cases like this, but I don't think it ever
>> happened.
>
> Umm...  In case of fallocate() the next argument is 64bit one, though;
> sys_fallocate() will be looking for two 32bit words on stack, so no
> matter how do we pass them to syscall, we'd better push two words in
> the wrapper.

Right.

> But yes, 32bit/32bit/64bit/32bit is another interesting case -
> fanotify_mark is 32/32/64/32/32.  From what ABI says it would seem to
> be r12/r11/r8:r9/r10/stack, but if I understand you correctly, we'll
> end up wanting *two* arguments on stack...

Yes, I think there may be a difference between the IAR and gcc ABI
here. But I could be wrong.

Havard
