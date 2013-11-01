Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3KASJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:09:19 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:44737 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KASJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20131101080135.GB25547@gmail.com>
	<1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 1 Nov 2013 11:09:15 -0700
X-Google-Sender-Auth: avZoMstxkfrrgV9p2TUE1tg-k6M
Message-ID: <CA+55aFzzdLn1xqyGobtP2yo7es+XOgt10Kr-9FRHvg-9eE3cyg@mail.gmail.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to rwlock_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 10:49 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Andrea's last input from this kind of conversion is that it cannot be
> done (at least yet): https://lkml.org/lkml/2013/9/30/53

No, none of the invalidate_page users really need to sleep. If doing
this makes some people not do stupid sh*t, then that's all good. So at
least _that_ worry was a false alarm. We definitely don't want to
support crap in the VM, and sleeping during teardown is crap.

                Linus
