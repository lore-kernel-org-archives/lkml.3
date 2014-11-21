Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbaKURTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:19:07 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37491 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbaKURTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:19:03 -0500
MIME-Version: 1.0
In-Reply-To: <20141121170805.GD30603@home.goodmis.org>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
	<CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
	<20141121170805.GD30603@home.goodmis.org>
Date: Fri, 21 Nov 2014 09:19:02 -0800
X-Google-Sender-Auth: GbGLuLUL_zwO9Ofc94jdKIJGcP8
Message-ID: <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 9:08 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Actually, in_nmi() is now safe for vmalloc faults. In fact, it handles the
> clobbering of the cr2 register just fine.

That's not what I object to and find incorrect wrt NMI.

Compare the simple and correct 32-bit code to the complex and
incorrect 64-bit code.

In particular, look at how the 32-bit code relies *entirely* on hardware state.

Then look at where the 64-bit code does not.

                      Linus
