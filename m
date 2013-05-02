Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3EBLOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:14:54 -0400
Received: from smtp1.uu.se ([130.238.7.54]:34608 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3EBLOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:14:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20866.18969.21166.669069@pilspetsen.it.uu.se>
Date: Thu, 2 May 2013 13:12:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Warlich, Christof" <christof.warlich@siemens.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DE481@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.43739.999287.287981@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
	<20863.55352.431848.272078@pilspetsen.it.uu.se>
	<6D83E89737156549AEA25EF9ED712C5DE3D0@DEFTHW99EK1MSX.ww902.siemens.net>
	<CAFLxGvyERB-00J9ZYUzphVd=C5wzBLnYWcP7U58sEmHLH5_-Jg@mail.gmail.com>
	<6D83E89737156549AEA25EF9ED712C5DE481@DEFTHW99EK1MSX.ww902.siemens.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warlich, Christof writes:
 > richard -rw- weinberger <richard.weinberger@gmail.com> writes:
 > > Are you telling us that Ubuntu shipped the wrong header file?
 > 
 > Hmm - at least I still don't know how to get the right definition
 > of uc_mcontext (with eglibc-2.13 on Ubuntu 11.10) ...
 > 
 > If I include both signal.h and asm-generic/ucontext.h, gcc reports
 > this error:
 > 
 > /usr/include/asm-generic/ucontext.h:4:8: error: redefinition of 'struct ucontext'
 > /usr/include/i386-linux-gnu/sys/ucontext.h:119:16: error: previous definition of 'struct ucontext'
 > 
 > Thus, signal.h obviously includes the wrong i386-linux-gnu/sys/ucontext.h
 > defining uc_mcontext to be of type mcontext_t.
 > 
 > So is it still me doing something wrong or or _did_ Ubuntu ship
 > the wrong header files?

#include <signal.h>
#include <ucontext.h>

has worked for my SIGFPE handlers on Linux for the last 10+ years on various distros
and target architectures.

Can we stop this thread now?  There is no _kernel_ issue here.
