Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab3D3Lhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:37:37 -0400
Received: from smtp1.uu.se ([130.238.7.54]:36855 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab3D3Lhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:37:36 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 07:37:36 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20863.43739.999287.287981@pilspetsen.it.uu.se>
Date: Tue, 30 Apr 2013 13:28:27 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Warlich, Christof" <christof.warlich@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
In-Reply-To: <6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warlich, Christof writes:
 > Andi Kleen <andi@firstfloor.org> writes:
 > > The FP registers are restored lazily, but the state for this is kept in
 > > the kernel.
 > 
 > I'm not sure if I understand "lazily" in this context: Do you mean that FP
 > registers _are_ restored within the kernel, but _not_ from a (possibly modified)
 > ucontext of a userspace signal handler? If so, do you know a reason why the GP
 > registers are so nicely restored from userspace, but not the FP registers?
 >  
 > > One easy way may be to catch the FPU exception too and clear from there?
 > 
 > Hmm - I _do_ catch SIGFPE in my userspace signal handler, but I obviously
 > can't clear the FP exceptions from there. This, together with your answer
 > so far, makes me conclude that there may be no way to achieve my goal from
 > userspace, right :-(?

Write to the fpstate ->mxcsr and ->swd fields in the sigaction handler's uc_mcontext.
