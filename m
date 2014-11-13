Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaKMOto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:49:44 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:41320 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbaKMOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:49:42 -0500
In-Reply-To: <3899236.yrOvvrZHD6@wuerfel>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <6358312.yt5WU3kBm9@wuerfel> <54645799.5010409@linaro.org> <3899236.yrOvvrZHD6@wuerfel>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
X-KeepSent: 152076B7:38277C08-C1257D8F:0050C2DF;
 type=4; name=$KeepSent
To: Arnd Bergmann <arnd@arndb.de>
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
X-Mailer: IBM Notes Release 9.0.1 October 14, 2013
Message-ID: <OF152076B7.38277C08-ONC1257D8F.0050C2DF-C1257D8F.00516BF2@de.ibm.com>
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Date: Thu, 13 Nov 2014 15:49:20 +0100
X-MIMETrack: Serialize by Router on D06ML032/06/M/IBM(Release 9.0.1FP2|August  03, 2014) at
 13/11/2014 15:49:32
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111314-0029-0000-0000-000001A87804
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote on 13.11.2014 11:21:28:

> I have to admit that I don't really understand gdb internals, but from
> a first look I get the impression that it will just do the right thing
> if you reuse NT_S390_SYSTEM_CALL on ARM64 with the same semantics.

There's an interface between BFD and GDB proper involved here.  BFD will
detect the presence of register set notes in the core dump, and will
translate them into virtual sections; GDB will then simply look up such
sections under well-known names.

In particular, the NT_S390_SYSTEM_CALL note will be translated by BFD
into a virtual section named ".reg-s390-system-call"; GDB platform-
specific code will look for sections of this particular name.

So if you were to create notes using the same note type, by default it
would do nothing on ARM64.  You might add code to the ARM64 back-end
to also look for a section ".reg-s390-system-call", but that would be
somewhat confusing.  Using a new, platform-specific note type for ARM64
would appear to fit better with existing precedent.

Bye,
Ulrich

