Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbaKMW0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:26:19 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57965 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:26:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: Andreas Krebbel1 <Andreas.Krebbel@de.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        linaro-kernel@lists.linaro.org,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Thu, 13 Nov 2014 23:25:29 +0100
Message-ID: <1472197.o98pKNTkBz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <OF152076B7.38277C08-ONC1257D8F.0050C2DF-C1257D8F.00516BF2@de.ibm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <3899236.yrOvvrZHD6@wuerfel> <OF152076B7.38277C08-ONC1257D8F.0050C2DF-C1257D8F.00516BF2@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cA0ll1yu12l4nf+msz++qB5dD8VH6zFwZxx0K23m2J5
 2df9CGokcY68txjZoPjatPYGA1/Mh5toXr1M8gQ7N7T5QV7AF9
 Q2YOEnsjT0KSoIFsiMA+qYhdTCjTRFpODz9RzmuZgHp6EDtoG6
 N4EwaRzHXEwvZSsipd7nZr3Kzp3ySxn8RdmXfDADY8JZ/PEIC4
 LESK0a1yanCDuW1TgDxi0BH+jntau53UFqJ+zQDxlkDtrWvG1L
 v4OQ/3FYD1qtz9lr+MwXLdXkh7Qcrgz2nZg1eQBwrKREs1LC//
 2lyu1pGMHWglqOkJ1+KmFjAWp7BHAAmypomLFx+n/YKbvcDU/G
 PYZ5m+8KEwLPTxIV0L1Q=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 15:49:20 Ulrich Weigand wrote:
> Arnd Bergmann <arnd@arndb.de> wrote on 13.11.2014 11:21:28:
> 
> > I have to admit that I don't really understand gdb internals, but from
> > a first look I get the impression that it will just do the right thing
> > if you reuse NT_S390_SYSTEM_CALL on ARM64 with the same semantics.
> 
> There's an interface between BFD and GDB proper involved here.  BFD will
> detect the presence of register set notes in the core dump, and will
> translate them into virtual sections; GDB will then simply look up such
> sections under well-known names.
> 
> In particular, the NT_S390_SYSTEM_CALL note will be translated by BFD
> into a virtual section named ".reg-s390-system-call"; GDB platform-
> specific code will look for sections of this particular name.
> 
> So if you were to create notes using the same note type, by default it
> would do nothing on ARM64.  You might add code to the ARM64 back-end
> to also look for a section ".reg-s390-system-call", but that would be
> somewhat confusing.  Using a new, platform-specific note type for ARM64
> would appear to fit better with existing precedent.

Ok, thanks a lot for your insight and for confirming what Takahiro AKASHI
said. Let's use a new NT_ARM64_SYSTEM_CALL type with a different
number then.

	Arnd
