Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab3CWRLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:11:47 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60136 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3CWRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:11:46 -0400
MIME-Version: 1.0
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Date: Sat, 23 Mar 2013 10:11:45 -0700
X-Google-Sender-Auth: 4zDkcSS9WlvhthqeUYXKvhaSCx4
Message-ID: <CA+55aFyWMqwBfd6aYfRaLpX6gGqNxEkD5TFM3HRQpi9nAhn+0g@mail.gmail.com>
Subject: Re: RFC: Kernel lock elision for TSX
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 6:24 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Some questions and answers:
>
> - How much does it improve performance?
> I cannot share any performance numbers at this point unfortunately.
> Also please keep in mind that the tuning is very preliminary and
> will be revised.

Quite frankly, since the *only* reason for RTM is performance, this
fundamentally makes the patch-set pointless.

If we don't know how much it helps, we can't judge whether it's worth
even discussing this patch. It adds enough complexity that it had
better be worth it, and without knowing the performance side, all we
can see are the negatives.

Talk to your managers about this. Tell them that without performance
numbers, any patch-series like this is totally pointless.

Does it make non-contended code slower? We don't know. Does it improve
anything but micro-benchmarks? We don't know. Is there any point to
this? WE DON"T KNOW.

Inside of intel, it might be useful for testing and validating the
hardware. Outside of intel, it is totally useless without performance
numbers.

The other comment I have is that since it does touch non-x86 header
files etc (although not a lot), you really need to talk to the POWER8
people about naming of the thing. Calling it <linux/rtm.h> and having
"generic" helpers called _xtest() used by the generic spinlock code
sounds a bit suspect.

                  Linus
