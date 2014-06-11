Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaFKEeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:34:18 -0400
Received: from ns.horizon.com ([71.41.210.147]:57131 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750757AbaFKEeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:34:17 -0400
Date: 11 Jun 2014 00:34:16 -0400
Message-ID: <20140611043416.13875.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140611020835.GA23110@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So have you actually instrumented the kernel to demonstrate that in
> fact we have super deep stack call paths where the 128 bytes worth of
> stack actually matters?

I haven't got a specific call chain where 128 bytes pushes it
over a limit.  But kernel stack usage is a perennial problem.
Wasn't there some discussion about that just recenty?
6538b8ea8: "x86_64: expand kernel stack to 16K"

I agree a 128 byte stack frame is not one of the worst offenders,
but it's enough to try to clean up if possible.

You can search LKML for a bunch of discussion of 176 bytes
in __alloc_pages_slowpath().

And in this case, it's so *easy*.  extract_buf() works 10 bytes at a
time anyway, and _mix_pool_bytes is byte at a time.

>> I hadn't tested the patch when I mailed it to you (I prepared it in
>> order to reply to your e-mail, and it's annoying to reboot the machine
>> I'm composing an e-mail on), but I have since.  It works.

> As an aside, I'd strongly suggest that you use kvm to do your kernel
> testing.  It means you can do a lot more testing which is always a
> good thing....

H'mmm. I need to learn what KVM *is*.  Apparently there's a second
meaning other than "keyboard, video & mouse". :-)

Normally, I just test using modules.  Especially when working on a
driver for a hardware device, virtualization makes life difficult.
But /dev/random is (for good reasons) not modularizable.

(I can see how it'd be useful for filesystem development, however.)
