Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3KJWQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 17:16:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33838 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3KJWQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 17:16:35 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1384117768.3081.10.camel@joe-AO722>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org> <1384117768.3081.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand size
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 10 Nov 2013 14:10:36 -0800
To: Joe Perches <joe@perches.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        james.t.kukunas@intel.com, hpa@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>
Message-ID: <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, on the generic it is int.

The problem is in part that some architectures have bitop instructions with specific behavior.

Joe Perches <joe@perches.com> wrote:
>On Tue, 2013-07-16 at 18:15 -0700, tip-bot for H. Peter Anvin wrote:
>> Commit-ID:  9b710506a03b01a9fdd83962912bc9d8237b82e8
>[]
>> x86, bitops: Change bitops to be native operand size
>> 
>> Change the bitops operation to be naturally "long", i.e. 63 bits on
>> the 64-bit kernel.  Additional bugs are likely to crop up in the
>> future.
>
>> We already have bugs which machines with > 16 TiB of memory in a
>> single node, as can happen if memory is interleaved.  The x86 bitop
>> operations take a signed index, so using an unsigned type is not an
>> option.
>
>I think it odd that any bitop index nr should be
>anything other than unsigned long for any arch.
>
>Why should this arch be any different than the
>defined type in Documentation/atomic_ops.txt?
>
>What value is a negative index when the bitmap
>array address passed is the starting 0th bit?
>
>btw: asm-generic/bitops.h doesn't match
>Documentation/atomic_ops.txt either.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
