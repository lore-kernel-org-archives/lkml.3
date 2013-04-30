Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3D3Gfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:35:52 -0400
Received: from gecko.sbs.de ([194.138.37.40]:23823 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab3D3Gfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:35:51 -0400
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
Thread-Topic: X86 fpu registers in a signal handler's ucontext
Thread-Index: AQHORQMJqvz3Ty+ARUuGAGM8sG/3EJjuQOkg
Date: Tue, 30 Apr 2013 06:35:36 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
 <m2a9ohusmp.fsf@firstfloor.org>
In-Reply-To: <m2a9ohusmp.fsf@firstfloor.org>
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

Andi Kleen <andi@firstfloor.org> writes:
> The FP registers are restored lazily, but the state for this is kept in
> the kernel.

I'm not sure if I understand "lazily" in this context: Do you mean that FP
registers _are_ restored within the kernel, but _not_ from a (possibly modified)
ucontext of a userspace signal handler? If so, do you know a reason why the GP
registers are so nicely restored from userspace, but not the FP registers?
 
> One easy way may be to catch the FPU exception too and clear from there?

Hmm - I _do_ catch SIGFPE in my userspace signal handler, but I obviously
can't clear the FP exceptions from there. This, together with your answer
so far, makes me conclude that there may be no way to achieve my goal from
userspace, right :-(?

Ok, still assuming I'm (terribly) right so far: The kernel calls
do_coprocessor_error() when the FP exception occurs. As I don't want to patch
the kernel, is there a "best practise" way to hook my module code into the FP
exception handler? The only way that comes to my mind is modifying the vector
table in modul_init() to let the FP exception point to my code and restoring
it in module_exit().  

> There can be some complications with different save formats too (XSAVE
> vs FXSAVE). So your solution may not be necessarily 100% portable
> to all systems.
Yes, I'm certainly arch specific in many ways here, but that wouldn't be much
of a problem for me though.