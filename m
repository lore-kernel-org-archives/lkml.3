Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab3CEBhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:37:14 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39198 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3CEBhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:37:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130303174056.GA30176@redhat.com>
References: <512CC509.1050000@linux.vnet.ibm.com>
	<CACvQF50UgiqPpDk3HCmV86zKSf6tPjqr0bZowfPEOJs0g0r0MQ@mail.gmail.com>
	<512D0D67.9010609@linux.vnet.ibm.com>
	<CACvQF53ph2ixdM-otzetjM5cR+2kcZj6sckOp3TnzzA_x-EZ8w@mail.gmail.com>
	<512E7879.20109@linux.vnet.ibm.com>
	<5130E8E2.50206@cn.fujitsu.com>
	<20130301182854.GA3631@redhat.com>
	<CANN689HEW=b5S93J27p+rBX-5m7jkW4FER=eHDCp7OgMaTWLPw@mail.gmail.com>
	<5131FB4C.7070408@cn.fujitsu.com>
	<20130302172003.GC29769@redhat.com>
	<20130303174056.GA30176@redhat.com>
Date: Mon, 4 Mar 2013 17:37:09 -0800
Message-ID: <CANN689F6RHCtDAiBGu=n60UKUEE5Ld50gkwS3rNdE2GN2+v3nA@mail.gmail.com>
Subject: Re: [PATCH V2] lglock: add read-preference local-global rwlock
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lai Jiangshan <eag0628@gmail.com>, linux-doc@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@sisk.pl,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> However, I still think that FALLBACK_BASE only adds the unnecessary
>> complications. But even if I am right this is subjective of course, please
>> feel free to ignore.

Would it help if I sent out that version (without FALLBACK_BASE) as a
formal proposal ?

> Hmm. But then I do not understand the lglock annotations. Obviously,
> rwlock_acquire_read() in lg_local_lock() can't even detect the simplest
> deadlock, say, lg_local_lock(LOCK) + lg_local_lock(LOCK). Not to mention
> spin_lock(X) + lg_local_lock(Y) vs lg_local_lock(Y) + spin_lock(X).
>
> OK, I understand that it is not easy to make these annotations correct...

I am going to send out a proposal to fix the existing lglock
annotations and detect the two cases you noticed. It's actually not
that hard :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
