Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3AUTsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3AUTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:48:09 -0500
Date: Mon, 21 Jan 2013 20:47:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 0/3] ptrace: ensure arch_ptrace/ptrace_request can never
	race with SIGKILL
Message-ID: <20130121194723.GA18775@redhat.com>
References: <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com> <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Linus Torvalds wrote:
>
> I guess that works then. It's a bit sad, but at least I see why you did it.

OK, please see v3 rebased on top of "unexport ptrace_check_attach()" you
already applied.

I tried to update the comment in ptrace_check_attach(), and changed unfreeze()
to simply do WARN_ON() without if/return.

There is also the cosmetic change in 1/3,

	-		ptrace_signal_wake_up(child, task_is_traced(child));
	+		ptrace_signal_wake_up(child, true);

in __ptrace_unlink().

Oleg.

