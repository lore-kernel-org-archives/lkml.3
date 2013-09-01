Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3IAQOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:14:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45939 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547Ab3IAQOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:14:32 -0400
Message-ID: <522367C5.8090800@zytor.com>
Date: Sun, 01 Sep 2013 09:13:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: On the correctness of dbe3ed1c078c193be34326728d494c5c4bc115e2
References: <5223311D.2040608@zytor.com> <CA+55aFwUKyJwphC7EFCgQKGLfZq1yrjx+4CrMhJeVmxFr8QNdg@mail.gmail.com> <522364AA.9050506@zytor.com> <CA+55aFxnXam2WFLDPao4YngpmxGstJ66XL6KC05pFfy9U0rtyA@mail.gmail.com>
In-Reply-To: <CA+55aFxnXam2WFLDPao4YngpmxGstJ66XL6KC05pFfy9U0rtyA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 09:12 AM, Linus Torvalds wrote:
> On Sun, Sep 1, 2013 at 9:00 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 09/01/2013 08:58 AM, Linus Torvalds wrote:
>>>
>>> Not necessarily. Don't we basically do exactly that for the F00F bug
>>> workaround, for example?
>>
>> We do, but only after matching on an exact address (is_f00f_bug()).
>> Note also that is_f00f_bug() isn't conditional on PF_USER.
> 
> Right. But I'm wondering why you care? There's nothing we can do about
> spurious page faults if they dp happen. The PF_USER thing we do means
> that bad_area_nosemaphore will go through the "send signal" path.
> 
> I guess we can remove the setting of PF_USER, but that would just mean
> that then we have to test for "is_user_vm()" in bad_area_semaphore
> instead. So the end result would be exactly the same.
> 
> And my point was that we actually do have this "users can cause page
> faults on IDT etc accesses" as a real thing.
> 
> So basically: what do you propose to do? You basically can't remove
> the line without adding it somewhere else.
> 

is_f00f_bug() already contains:

                if (nr == 6) {
                        do_invalid_op(regs, 0);
                        return 1;
                }

... that's where we're supposed to issue SIGILL.

	-hpa

