Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3BYKqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:46:39 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51718 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3BYKqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:46:37 -0500
MIME-Version: 1.0
In-Reply-To: <512B3957.1020505@parallels.com>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
	<512B3957.1020505@parallels.com>
Date: Mon, 25 Feb 2013 14:46:36 +0400
Message-ID: <CANaxB-y_=267DABXjBdxjM=unt34mTnC8UQ64on7dHezta31gQ@mail.gmail.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 from a queue (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/25 Pavel Emelyanov <xemul@parallels.com>:
>> +     for (i = 0; i < arg.nr; i++) {
>> +             off = arg.off + i;
>> +
>> +             spin_lock_irq(&child->sighand->siglock);
>> +             list_for_each_entry(q, &pending->list, list) {
>> +                     if (!off--) {
>> +                             copy_siginfo(&info, &q->info);
>> +                             break;
>> +                     }
>> +             }
>> +             spin_unlock_irq(&child->sighand->siglock);
>
> What's the point of arg.nr if you for every single siginfo drop the lock
> and perform linear search anyway?

arg.nr may be useful, if we will decide to optimize this part in a
future. Currently the problem with complexity of finding a signal in a
queue is true not only for this code. It exists for delivering
real-time signals as well. Probably in a future this problem will be
fixed for both cases by the same way.

Thanks,
  Andrew
