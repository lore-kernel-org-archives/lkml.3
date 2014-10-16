Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaJPNkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:40:40 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:34965 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaJPNkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <20141016092232.570be048@mschwide>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo5E6zxtogVjMqZiUGAoRz6mMudSUqcH9B+DZ-R8xYN2kQ@mail.gmail.com> <20141016092232.570be048@mschwide>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 16 Oct 2014 07:40:16 -0600
Message-ID: <CAErSpo6timzQ7YDj=SMyCT=g4tgb5i4zua4OUYsYcg8Ur-J-SQ@mail.gmail.com>
Subject: Re: [PATCH v1 06/10] clocksource: Remove "weak" from
 clocksource_default_clock() declaration
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 1:22 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Wed, 15 Oct 2014 17:30:33 -0600
> Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> [+cc Daniel, Martin, linux-s390; sorry, I botched my "stg mail" so you
>> weren't included the first time.  s390 could see issues from this.]
>>
>> On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > kernel/time/jiffies.c provides a default clocksource_default_clock()
>> > definition explicitly marked "weak".  arch/s390 provides its own definition
>> > intended to override the default, but the "weak" attribute on the
>> > declaration applied to the s390 definition as well, so the linker chose one
>> > based on link order (see 10629d711ed7 ("PCI: Remove __weak annotation from
>> > pcibios_get_phb_of_node decl")).
>> >
>> > Remove the "weak" attribute from the clocksource_default_clock()
>> > declaration so we always prefer a non-weak definition over the weak one,
>> > independent of link order.
>> >
>> > Fixes: f1b82746c1e9 ("clocksource: Cleanup clocksource selection")
>> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> > CC: Daniel Lezcano <daniel.lezcano@linaro.org>
>> > CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> > ---
>> >  include/linux/clocksource.h |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
>> > index 653f0e2b6ca9..abcafaa20b86 100644
>> > --- a/include/linux/clocksource.h
>> > +++ b/include/linux/clocksource.h
>> > @@ -287,7 +287,7 @@ extern struct clocksource* clocksource_get_next(void);
>> >  extern void clocksource_change_rating(struct clocksource *cs, int rating);
>> >  extern void clocksource_suspend(void);
>> >  extern void clocksource_resume(void);
>> > -extern struct clocksource * __init __weak clocksource_default_clock(void);
>> > +extern struct clocksource * __init clocksource_default_clock(void);
>> >  extern void clocksource_mark_unstable(struct clocksource *cs);
>> >
>> >  extern u64
>> >
>
> s390 compiles and boots without the __weak for clocksource_default_clock.

I assume this means you've tested this patch and s390 compiles and boots?

I assume you *don't* mean that s390 could drop its
clocksource_default_clock() implementation and use the generic one,
right?

Bjorn
