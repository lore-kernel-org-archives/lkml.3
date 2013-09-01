Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3IAQMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:12:48 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47721 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IAQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <522364AA.9050506@zytor.com>
References: <5223311D.2040608@zytor.com>
	<CA+55aFwUKyJwphC7EFCgQKGLfZq1yrjx+4CrMhJeVmxFr8QNdg@mail.gmail.com>
	<522364AA.9050506@zytor.com>
Date: Sun, 1 Sep 2013 09:12:44 -0700
X-Google-Sender-Auth: L93zlSSVFRvLeI4_jtSlP00pRX0
Message-ID: <CA+55aFxnXam2WFLDPao4YngpmxGstJ66XL6KC05pFfy9U0rtyA@mail.gmail.com>
Subject: Re: On the correctness of dbe3ed1c078c193be34326728d494c5c4bc115e2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 9:00 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/01/2013 08:58 AM, Linus Torvalds wrote:
>>
>> Not necessarily. Don't we basically do exactly that for the F00F bug
>> workaround, for example?
>
> We do, but only after matching on an exact address (is_f00f_bug()).
> Note also that is_f00f_bug() isn't conditional on PF_USER.

Right. But I'm wondering why you care? There's nothing we can do about
spurious page faults if they dp happen. The PF_USER thing we do means
that bad_area_nosemaphore will go through the "send signal" path.

I guess we can remove the setting of PF_USER, but that would just mean
that then we have to test for "is_user_vm()" in bad_area_semaphore
instead. So the end result would be exactly the same.

And my point was that we actually do have this "users can cause page
faults on IDT etc accesses" as a real thing.

So basically: what do you propose to do? You basically can't remove
the line without adding it somewhere else.

                  Linus
