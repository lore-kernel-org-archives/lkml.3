Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab3IAQBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:01:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45835 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab3IAQBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:01:23 -0400
Message-ID: <522364AA.9050506@zytor.com>
Date: Sun, 01 Sep 2013 09:00:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: On the correctness of dbe3ed1c078c193be34326728d494c5c4bc115e2
References: <5223311D.2040608@zytor.com> <CA+55aFwUKyJwphC7EFCgQKGLfZq1yrjx+4CrMhJeVmxFr8QNdg@mail.gmail.com>
In-Reply-To: <CA+55aFwUKyJwphC7EFCgQKGLfZq1yrjx+4CrMhJeVmxFr8QNdg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 08:58 AM, Linus Torvalds wrote:
> On Sun, Sep 1, 2013 at 5:20 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> This has the end result that we treat a user space instruction which
>> touches a privileged data structure that then page faults (e.g. a
>> segment load which causes #PF on the GDT) as a user-space fault.
>>
>> This seems very wrong to me, since such a #PF would indicate a serious
>> error in the kernel.
> 
> Not necessarily. Don't we basically do exactly that for the F00F bug
> workaround, for example?
> 

We do, but only after matching on an exact address (is_f00f_bug()).
Note also that is_f00f_bug() isn't conditional on PF_USER.

	-hpa

