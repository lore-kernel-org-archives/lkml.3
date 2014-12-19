Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaLSUqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:46:18 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46643 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLSUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyb6N47N2Jg75EmRxDTjFF2y_oy4dHNDeW_dyM4PUTDrA@mail.gmail.com>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<CA+55aFyb6N47N2Jg75EmRxDTjFF2y_oy4dHNDeW_dyM4PUTDrA@mail.gmail.com>
Date: Fri, 19 Dec 2014 12:46:16 -0800
X-Google-Sender-Auth: You7DKQwRN81s16e-dxw32tvhMY
Message-ID: <CA+55aFzt_4Zrnek6381JFzm+3iV9d=JAeyx+=E9F8BeiWFb56g@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 11:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I do note that we depend on the "new mwait" semantics where we do
> mwait with interrupts disabled and a non-zero RCX value. Are there
> possibly even any known CPU errata in that area? Not that it sounds
> likely, but still..

Remind me what CPU you have in that machine again? The %rax value for
the mwait cases in question seems to be 0x32, which is either C7s-HSW
or C7s-BDW, and in both cases has the "TLB flushed" flag set.

I'm pretty sure you have a Haswell, I'm just checking. Which model?
I'm assuming it's family 6, model 60, stepping 3? I found you
mentioning i5-4670T in a perf thread.. That the one?

Anyway, I don't actually believe in any CPU bugs, but you could try
"intel_idle.max_cstate=0" and see if that makes any difference, for
example.

Or perhaps just "intel_idle.max_cstate=1", which leaves intel_idle
active, but gets rid of the deeper sleep states (that incidentally
also play games with leave_mm() etc)

                            Linus
