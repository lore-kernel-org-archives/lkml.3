Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3APMCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:02:53 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:65523 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3APMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:02:52 -0500
MIME-Version: 1.0
In-Reply-To: <50F683D9.1080908@linux.vnet.ibm.com>
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com>
	<50E3FDFA.4070203@suse.cz>
	<20130102114311.66215bf5@pyramind.ukuu.org.uk>
	<CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com>
	<50E4854E.8060801@suse.cz>
	<CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
	<50F66120.50704@linux.vnet.ibm.com>
	<CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com>
	<50F683D9.1080908@linux.vnet.ibm.com>
Date: Wed, 16 Jan 2013 13:02:51 +0100
Message-ID: <CAMSQXEHjP5mzs9u5DUmuYgoEceM2OO=E8844-XQ7LPCSECoGRw@mail.gmail.com>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/16 Preeti U Murthy <preeti@linux.vnet.ibm.com>:
>
> Yes.Thank you very much for the explanation :) But I dont see how the
> context switching goes away with your patch.With your patch, when the
> higher priority thread comes in when the lower priority thread is
> running in the critical section,it will see the wait queue empty and
> "continue its execution" without now wanting to enter the critical
> section.So this means it will preempt the lower priority thread because
> it is not waiting on a lock anyway.There is a context switch here right?
> I dont see any problem in scheduling due to this,but I do think your
> patch is essential.
>

I don't have a problem that there is a context switch to the high
priority process: it has a higher priority, so it probably is more
important.
My problem is that even when the waitqueue is empty, the high priority
thread has a risk to block on the spinlock needlessly (causing context
switches to low priority task and back to the high priority task)

Regards,
Ivo Sieben
