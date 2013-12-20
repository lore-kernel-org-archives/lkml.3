Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3LTTy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:54:26 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37054 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3LTTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <1387567810.2704.19.camel@buesod1.americas.hpqcorp.net>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
	<CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	<1387567810.2704.19.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 20 Dec 2013 11:54:24 -0800
X-Google-Sender-Auth: IW8qz-Pejrxu6XGR36IJiqpDd74
Message-ID: <CA+55aFwj_zWyUb8w3nqoWbmRXcHSsuYD2BrJ+aD8x7A0Sg6ZXw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 11:30 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> So we'd need the barrier right after the ticket increment (ie: the xadd
> TICKET_LOCK_INC in x86), and cannot rely on the barrier after the lock
> is taken as we could miss waiters that are just spinning trying to take
> it. Is this implicitly guaranteed across all archs?

Not necessarily. But I don't see why threads spinning on it would be
special? If you spin on things, you've already updated the head
counter, so even spinners *are* visible, even if they haven't actually
gotten the lock yet.

                 Linus
