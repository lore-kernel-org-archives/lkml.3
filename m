Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3CBVU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:20:28 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30906 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3CBVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:20:26 -0500
Message-ID: <1362259221.3602.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 02 Mar 2013 13:20:21 -0800
In-Reply-To: <CA+i8gKJKmZJD8UXGRYrA1X8qO1EqJMJ7eC_qOuDqvEX93ZNYUA@mail.gmail.com>
References: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
	 <CA+i8gKJ99-f0Q=kqf2=zY_kjSt8UE6jq0nETWmW0fSdnh00vCw@mail.gmail.com>
	 <CANN689HH_bqGSjZ15ftnd_Ogm4YQVJj0_OEQ13nofdEy8WtUmw@mail.gmail.com>
	 <CA+i8gKJKmZJD8UXGRYrA1X8qO1EqJMJ7eC_qOuDqvEX93ZNYUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 15:35 +0700, Emmanuel Benisty wrote:
> On Sat, Mar 2, 2013 at 2:08 PM, Michel Lespinasse <walken@google.com> wrote:
> > On Sat, Mar 2, 2013 at 12:43 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> >> Hi,
> >>
> >> On Sat, Mar 2, 2013 at 7:16 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> >>> The following set of not-thoroughly-tested patches are based on the
> >>> discussion of holding the ipc lock unnecessarily, such as for permissions
> >>> and security checks:
> >>>
> >>> https://lkml.org/lkml/2013/2/28/540
> >>>
> >>> Patch 0/1: Introduces new functions, analogous to ipc_lock and ipc_lock_check
> >>> in the ipc utility code, allowing to obtain the ipc object without holding the lock.
> >>>
> >>> Patch 0/2: Use the new functions and only acquire the ipc lock when needed.
> >>
> >> Not sure how much a work in progress this is but my machine dies
> >> immediately when I start chromium, crappy mobile phone picture here:
> >> http://i.imgur.com/S0hfPz3.jpg
> >
> > We are missing the top of the trace there, so it's hard to be sure -
> > however, this could well be caused by the if (!out) check (instead of
> > if (IS_ERR(out)) that I noticed in patch 1/2.
> 
> Merci Michel but unfortunately, I'm still getting the same issue.

Will try to reproduce (and further testing on other machines) and debug
later today.

Thanks for testing,
Davidlohr

