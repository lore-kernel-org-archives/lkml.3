Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3FDGBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:01:01 -0400
Received: from ozlabs.org ([203.10.76.45]:40410 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3FDGAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Greear <greearb@candelatech.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <51ACC60B.8090504@candelatech.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 04 Jun 2013 15:26:28 +0930
Message-ID: <87d2s2to4z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:
>> It at least works around the problem for me as well.  But, a more rare
>> migration/[0-3] (I think) related lockup still exists in 3.9.4 for me,
>> so I will also try applying that other kobject patch and continue testing
>> today...
>
> Well, that other kobject patch is already in 3.9.4, so I think it's still
> a good idea to include the
> "module: don't unlink the module until we've removed all exposure."
> patch in stable.  I have a decent test case to reproduce the crash, so if someone
> wants me to test other patches instead, then I will do so.

OK, I cannot reproduce on 3.9.4.  I #if 0'd out the WARNs in sysfs and
kobject, and did this (which reliably broke on 3.8):

# M=`modinfo -F filename e1000`
# for i in `seq 10000`; do insmod $M; rmmod e1000; done >/dev/null 2>&1 & for i in `seq 10000`; do insmod $M; rmmod e1000; done > /dev/null 2>&1 & for i in `seq 10000`; do insmod $M; rmmod e1000; done > /dev/null 2>&1 & for i in `seq 10000`; do insmod $M; rmmod e1000; done >/dev/null 2>&1 &
# 

This was under kvm, 4-way SMP, init=/bin/bash.

Do you have a backtrace of the 3.9.4 crash?  You can add "CFLAGS_module.o
= -O0" to get a clearer backtrace if you want...

Thanks,
Rusty.
