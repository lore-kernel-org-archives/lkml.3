Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3EBJFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:05:17 -0400
Received: from gecko.sbs.de ([194.138.37.40]:18682 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3EBJFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:05:14 -0400
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
Thread-Topic: X86 fpu registers in a signal handler's ucontext
Thread-Index: AQHORwObqvz3Ty+ARUuGAGM8sG/3EJjxjzqA
Date: Thu, 2 May 2013 09:04:51 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DE481@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.43739.999287.287981@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.55352.431848.272078@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE3D0@DEFTHW99EK1MSX.ww902.siemens.net>
 <CAFLxGvyERB-00J9ZYUzphVd=C5wzBLnYWcP7U58sEmHLH5_-Jg@mail.gmail.com>
In-Reply-To: <CAFLxGvyERB-00J9ZYUzphVd=C5wzBLnYWcP7U58sEmHLH5_-Jg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [139.22.70.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:
> Are you telling us that Ubuntu shipped the wrong header file?

Hmm - at least I still don't know how to get the right definition
of uc_mcontext (with eglibc-2.13 on Ubuntu 11.10) ...

If I include both signal.h and asm-generic/ucontext.h, gcc reports
this error:

/usr/include/asm-generic/ucontext.h:4:8: error: redefinition of 'struct ucontext'
/usr/include/i386-linux-gnu/sys/ucontext.h:119:16: error: previous definition of 'struct ucontext'

Thus, signal.h obviously includes the wrong i386-linux-gnu/sys/ucontext.h
defining uc_mcontext to be of type mcontext_t.

So is it still me doing something wrong or or _did_ Ubuntu ship
the wrong header files?