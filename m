Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaKZSXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:23:47 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:40064 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:23:46 -0500
MIME-Version: 1.0
In-Reply-To: <54761406.9090602@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com>
	<CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>
	<54761406.9090602@oracle.com>
Date: Wed, 26 Nov 2014 10:23:45 -0800
X-Google-Sender-Auth: T6XwiTn1Qfn522LC9LetOHh4Xb8
Message-ID: <CA+55aFz8TUtKtkPzQVHAS+-RfNmd6W=CQq4BRcEux+mf8tYtqw@mail.gmail.com>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, mingo <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 9:55 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Good point. Do you think there's an advantage in using GCC's overflow
> checker in this case?

No. However, if your coccinelle script can be changed to verify that
the type of the expression is unsigned, _that_ would be useful.

And the "multiplication overflow" may actually be a way to generate
better code. Possibly. I'm not entirely sure exactly what gcc actually
does. How many multiplication overflow tests do we actually have,
though?

For plain unsigned additions, "a + b < a" is already optimal (ie gcc
realizes it's an overflow check and generates a test against the carry
flag, at least when it doesn't screw up)

                     Linus
