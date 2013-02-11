Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3BKKay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:30:54 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38564 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3BKKaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:30:52 -0500
MIME-Version: 1.0
In-Reply-To: <5118C458.2070205@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
	<1359024639-21915-9-git-send-email-vgupta@synopsys.com>
	<51189D2F.4030000@synopsys.com>
	<CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com>
	<5118C458.2070205@synopsys.com>
Date: Mon, 11 Feb 2013 11:30:50 +0100
Message-ID: <CACM3HyF2GHz5PKuurYG2Hg+UEKeto+zme5gcv2fxQDC=tpZYRw@mail.gmail.com>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal handling)
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 11:13, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> On Monday 11 February 2013 03:06 PM, Jonas Bonn wrote:
>> On 11 February 2013 08:26, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>
>>> The only downside of this patch is that userspace signal stack grows in size,
>>> since signal frame only cares about scratch regs (pt_regs), but has to accommodate
>>> unused placeholder for callee regs too by virtue of using user_regs_struct.
>> Is this really true?  Don't setcontext and friends require that _all_
>> the registers be part of sigcontext?
>
> But for an ABI - callee saved regs will anyhow be saved/restored even in
> setcontext case ! So collecting it for that purpose seems useless, or am I missing
> something here.

Yes, I agree with you on the ABI bit... but set/get/swapcontext are
special in that they use rt_sigreturn to "trick" the kernel into
swapping out _all_ registers; it's a light-weight (userspace) context
switch.

(I really don't know this area very well, though, so I'm hoping
somebody more knowledgable jumps in here... Al?)

/Jonas
