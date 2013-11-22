Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3KVVOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:14:06 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37021 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3KVVOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <528FBFFA.1000807@hp.com>
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
	<1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFzkqP84M7L6j__QHuks7DXTQnGqdCo3=a=u7qKdER9rEQ@mail.gmail.com>
	<528FBFFA.1000807@hp.com>
Date: Fri, 22 Nov 2013 13:14:03 -0800
X-Google-Sender-Auth: jz2-irqR10niCvGq_TYFGvUUbG0
Message-ID: <CA+55aFxW70iKq5YT-icVuvsmH=xapMd5e+OnbL-8JbX7fD4M-Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:35 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> Yes, the extra latency of the fair lock in earlier patch is due to the need
> to do a second cmpxchg(). That can be avoided by doing a read first, but
> that is not good for good cache.  So I optimized it for the default unfair
> lock. By supporting only one version, there is no need to do a second
> cmpxchg anymore.

Ok, thanks.

> I reran the timing test on the 2.93GHz processor. The timing is the
> practically the same. I reused the old one for the 2.4GHz processor.

Sounds good. I just wanted to make sure the numbers were sane.

            Linus
