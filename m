Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3CBIfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 03:35:06 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34834 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3CBIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 03:35:04 -0500
MIME-Version: 1.0
In-Reply-To: <CANN689HH_bqGSjZ15ftnd_Ogm4YQVJj0_OEQ13nofdEy8WtUmw@mail.gmail.com>
References: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gKJ99-f0Q=kqf2=zY_kjSt8UE6jq0nETWmW0fSdnh00vCw@mail.gmail.com>
	<CANN689HH_bqGSjZ15ftnd_Ogm4YQVJj0_OEQ13nofdEy8WtUmw@mail.gmail.com>
Date: Sat, 2 Mar 2013 15:35:02 +0700
Message-ID: <CA+i8gKJKmZJD8UXGRYrA1X8qO1EqJMJ7eC_qOuDqvEX93ZNYUA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@redhat.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 2:08 PM, Michel Lespinasse <walken@google.com> wrote:
> On Sat, Mar 2, 2013 at 12:43 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>> Hi,
>>
>> On Sat, Mar 2, 2013 at 7:16 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>>> The following set of not-thoroughly-tested patches are based on the
>>> discussion of holding the ipc lock unnecessarily, such as for permissions
>>> and security checks:
>>>
>>> https://lkml.org/lkml/2013/2/28/540
>>>
>>> Patch 0/1: Introduces new functions, analogous to ipc_lock and ipc_lock_check
>>> in the ipc utility code, allowing to obtain the ipc object without holding the lock.
>>>
>>> Patch 0/2: Use the new functions and only acquire the ipc lock when needed.
>>
>> Not sure how much a work in progress this is but my machine dies
>> immediately when I start chromium, crappy mobile phone picture here:
>> http://i.imgur.com/S0hfPz3.jpg
>
> We are missing the top of the trace there, so it's hard to be sure -
> however, this could well be caused by the if (!out) check (instead of
> if (IS_ERR(out)) that I noticed in patch 1/2.

Merci Michel but unfortunately, I'm still getting the same issue.
