Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbaKXUTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:19:16 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:62185 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaKXUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141124194200.GR5050@linux.vnet.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
	<1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
	<15567.1416835858@warthog.procyon.org.uk>
	<CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com>
	<CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com>
	<547381D7.2070404@de.ibm.com>
	<CA+55aFy+dunTcdgB4-BXsYiLDk9pf8b_L74ky-dMixpbX3JQQA@mail.gmail.com>
	<20141124194200.GR5050@linux.vnet.ibm.com>
Date: Mon, 24 Nov 2014 12:19:11 -0800
X-Google-Sender-Auth: S40EyHyVWG8YXdrYPWklmHtLI0k
Message-ID: <CA+55aFwJEqMv00zkwHmp_LOg74RU3e30-oo6RaYb=yGjgGr2cg@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:42 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> OK, how about the following?

Ugh. Disgusting.

Why the heck isn't it just "sizeof(*__vp) <= sizeof(long)"?

If the architecture has a 3-byte scalar type, then it probably has a
3-byte load.

> It complains if the variable is too large, for example, long long on
> 32-bit systems or large structures.  It is OK loading from and storing
> to small structures as well, which I am having a hard time thinking of
> as a disadvantage.

.. but that's *exactly* the gcc bug in question. It's a word-sized
struct that gcc loads twice.

                          Linus
