Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3ARPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3ARPqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:46:40 -0500
Date: Fri, 18 Jan 2013 16:45:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ivo Sieben <meltedpianoman@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
	queue is active
Message-ID: <20130118154504.GA28072@redhat.com>
References: <50E3FDFA.4070203@suse.cz> <20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com> <50F66120.50704@linux.vnet.ibm.com> <CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com> <50F683D9.1080908@linux.vnet.ibm.com> <CAMSQXEHjP5mzs9u5DUmuYgoEceM2OO=E8844-XQ7LPCSECoGRw@mail.gmail.com> <50F7D8C2.1030506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F7D8C2.1030506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Preeti U Murthy wrote:
>
> On 01/16/2013 05:32 PM, Ivo Sieben wrote:
> >
> > I don't have a problem that there is a context switch to the high
> > priority process: it has a higher priority, so it probably is more
> > important.
> > My problem is that even when the waitqueue is empty, the high priority
> > thread has a risk to block on the spinlock needlessly (causing context
> > switches to low priority task and back to the high priority task)
> >
> Fair enough Ivo.I think you should go ahead with merging the
> waitqueue_active()
>   wake_up()
> logic into the wake_up() variants.

This is not easy. We can't simply change wake_up*() helpers or modify
__wake_up().

I can't understand why do you dislike Ivo's simple patch. There are
a lot of "if (waitqueue_active) wake_up" examples. Even if we add the
new helpers (personally I don't think this makes sense) , we can do
this later. Why should we delay this fix?

Oleg.

