Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3ATUXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 15:23:51 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57823 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3ATUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 15:23:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130120192547.GD6771@redhat.com>
References: <20130116181830.GA6469@redhat.com> <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com>
 <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com>
 <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com>
 <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com>
 <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
 <20130120192448.GA6771@redhat.com> <20130120192547.GD6771@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 12:23:29 -0800
X-Google-Sender-Auth: n2pfkNnkP_RkLAqQbFEVzvXLBxw
Message-ID: <CA+55aFy_ozUj78-d8JSry6D=vD0--mPHkZx9Cvwfk5RFNo2OXw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ia64: kill thread_matches(), unexport ptrace_check_attach()
To: Oleg Nesterov <oleg@redhat.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 11:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> arch/ia64/kernel/ptrace.c:thread_matches() has no users since e868a55c
> "[IA64] remove find_thread_for_addr()", remove it.

I think this one should go first, so that there are no stale callers
of ptrace_check_attach() when you change the semantics. In fact, I'll
apply it immediately, since it's clearly correct and independent of
the other changes.

              Linus
