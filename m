Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3A2J2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:28:55 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47617 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3A2J2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:28:53 -0500
Date: Tue, 29 Jan 2013 10:28:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: nan chen <nachenn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130129092849.GA6665@gmail.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20130124161413.a3903fa4.akpm@linux-foundation.org>
 <20130125074053.GD18243@gmail.com>
 <CABBm8944FSNDZ2u=PJy0CsZmz=Vm7e+Y5jX+3UFLN5NOSGRgWQ@mail.gmail.com>
 <20130125092422.GA19541@gmail.com>
 <CABBm896XGVkubML9TyW_MTXMovd6nHoK0v24jbEDJOipzNqpDA@mail.gmail.com>
 <20130129090126.GA5547@gmail.com>
 <CABBm8979+XVRA-MQRdczMbStJR7DyPwNUvQL+RTuQL0sECOo8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBm8979+XVRA-MQRdczMbStJR7DyPwNUvQL+RTuQL0sECOo8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* nan chen <nachenn@gmail.com> wrote:

> > #define spin_lock_mutex(lock, flags)                    \
> >         do {                                            \
> >                 struct mutex *l = container_of(lock, struct mutex,
> > wait_lock); \
> >                                                         \
> >                 DEBUG_LOCKS_WARN_ON(in_interrupt());    \
> >                 local_irq_save(flags);                  \
> >                 arch_spin_lock(&(lock)->rlock.raw_lock);\
> >                 DEBUG_LOCKS_WARN_ON(l->magic != l);     \
> >         } while (0)
> >
> > The original question was why mutex-debug.h (unmodified) uses
> > irq disabling.
> >
> > Thanks,
> >
> >         Ingo
> >
> 
> So, the reason why you use WARN_ON here is try to keep things 
> going?

What would be the alternative?

Thanks,

	Ingo
