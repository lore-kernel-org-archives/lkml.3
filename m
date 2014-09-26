Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbaIZWLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:11:45 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:22304
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751503AbaIZWLo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:11:44 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "sebastian@fds-team.de" <sebastian@fds-team.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
Thread-Topic: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
Thread-Index: AQHP2PjujZWZAPWsuEKdVk/F+NXXnJwUbgaA//+NHWA=
Date: Fri, 26 Sep 2014 22:10:30 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88F4B57@nice.asicdesigners.com>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
 <20140926170041.700f44bd@as>
In-Reply-To: <20140926170041.700f44bd@as>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.161.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chuck Ebbert [mailto:cebbert.lkml@gmail.com]
> Sent: Friday, September 26, 2014 3:01 PM
> To: Anish Bhatt
> Cc: linux-kernel@vger.kernel.org; x86@kernel.org; tglx@linutronix.de;
> mingo@redhat.com; hpa@zytor.com; sebastian@fds-team.de; Linus
> Torvalds
> Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
> 
> On Thu, 25 Sep 2014 12:42:51 -0700
> Anish Bhatt <anish@chelsio.com> wrote:
> 
> > The MSR_SYSCALL_MASK, which is responsible for clearing specific
> > EFLAGS on  syscall entry, should also clear the nested task (NT) flag
> > to be safe from  userspace injection. Without this fix the application
> > segmentation  faults on syscall return because of the changed meaning
> > of the IRET  instruction.
> >
> > Further details can be seen here
> > https://bugs.winehq.org/show_bug.cgi?id=33275
> >
> > Signed-off-by: Anish Bhatt <anish@chelsio.com>
> > Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
> > ---
> >  arch/x86/kernel/cpu/common.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/cpu/common.c
> > b/arch/x86/kernel/cpu/common.c index e4ab2b4..3126558 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1184,7 +1184,7 @@ void syscall_init(void)
> >  	/* Flags to clear on syscall */
> >  	wrmsrl(MSR_SYSCALL_MASK,
> >  	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
> > -	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
> > +	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
> >  }
> >
> >  /*
> 
> I don't get it. Why isn't this patch acceptable, at least on x86-64 where NT is
> never valid?
> 
> Bueller?

Chuck, I don't think anyone has gotten around to reviewing, accepting or 
 rejecting this patch yet.
-Anish
