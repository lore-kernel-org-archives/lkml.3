Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3CLEDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:03:25 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34549 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3CLEDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130312033906.GA3725@linux.vnet.ibm.com>
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
	<CAFTL4hyO7HxGYOL=Fvq-g3LY37PY2f+xR6+stA7-wNkh3wkV=Q@mail.gmail.com>
	<CACVXFVMu9FNTghOQjNryY59S6xkRqg9DR5=OshngUDEZ5Fb=4w@mail.gmail.com>
	<20130312033906.GA3725@linux.vnet.ibm.com>
Date: Tue, 12 Mar 2013 12:03:23 +0800
Message-ID: <CACVXFVMuhFoPat7FAznr4ji5vXeeVBNCWya=JdYGLYqBv5SFUQ@mail.gmail.com>
Subject: Re: [PATCH] atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
From: Ming Lei <tom.leiming@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:39 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Atomic operations that return a value are required to act as full memory
> barriers.  This means that code relying on ordering provided by these
> atomic operations must also do ordering, either by using an explicit
> memory barrier or by relying on guarantees from atomic operations.
>
> For example:
>
>         CPU 0                                   CPU 1
>
>         X = 1;                                  r1 = Z;
>         if (atomic_inc_unless_negative(&Y)      smp_mb();
>                 do_something();
>         Z = 1;                                  r2 = X;
>
> Assuming X and Z are initially zero, if r1==1, we are guaranteed
> that r2==1.  However, CPU 1 needs its smp_mb() in order to pair with
> the barrier implicit in atomic_inc_unless_negative().
>
> Make sense?

Yes, it does, and thanks for the explanation.

But looks the above example is not what Frederic described:

"the above atomic_read() might return -1 because there is no
guarantee it's seeing the recent update on the remote CPU."

Even I am not sure if adding one smp_mb() around atomic_read()
can guarantee that too.

Andrew, please ignore the patch, thanks.

Thanks,
-- 
Ming Lei
