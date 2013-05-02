Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3EBHoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:44:08 -0400
Received: from gecko.sbs.de ([194.138.37.40]:15790 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab3EBHoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:44:04 -0400
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
Thread-Topic: X86 fpu registers in a signal handler's ucontext
Thread-Index: AQHORwObqvz3Ty+ARUuGAGM8sG/3EJjxeW8g
Date: Thu, 2 May 2013 07:43:37 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DE41B@DEFTHW99EK1MSX.ww902.siemens.net>
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

Grmpf ... no. :-*

Here again, I obviously started looking at the wrong file
(i386-linux-gnu/sys/ucontext.h), which defines uc_mcontext
to be of type mcontext_t.

So the right header to be used seems to be asm-generic/ucontext.h,
which _does_ include the right definition of uc_mcontext to be of
type struct sigcontext even in Ubuntu 11.10.

Thanks again and sorry for the confusion, I hope I have my lesson
learned.


