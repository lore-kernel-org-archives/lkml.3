Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaKTXej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:34:39 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55966 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaKTXei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
References: <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
	<20141119190215.GA10796@lerouge>
	<alpine.DEB.2.11.1411192251120.3909@nanos>
	<20141119225615.GA11386@lerouge>
	<alpine.DEB.2.11.1411200002330.3909@nanos>
	<20141119235033.GE11386@lerouge>
	<20141120122339.GA14877@htj.dyndns.org>
	<alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
Date: Thu, 20 Nov 2014 15:34:37 -0800
X-Google-Sender-Auth: SIxhfM4nljciq4kGwtL3oRrG1ac
Message-ID: <CA+55aFzcDABV6cXZB6fPGbi005SH5=swCVbcHTf7dcDkTQqVSw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:08 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> What's the issue with nmi?  Page faults are supposed to nest correctly
> inside nmi, right?

They should, now, yes. There used to be issues with the whole "that
re-enables NMI".

Which reminds me. We never took your patches that use ljmp to handle
the return-to-kernel mode. You did them for performance reasons, but I
think the bigger deal was that it would have cleaned up that whole
special case.

Or did they have other problems? The ones to return to user space were
admittedly more fun, but just a tad too crazy (and not _quite_ in the
"crazy like a fox" camp ;)

            Linus
