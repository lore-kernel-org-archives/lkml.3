Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaEAV64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:58:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41165 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaEAV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:58:55 -0400
Message-ID: <5362C37E.2090603@zytor.com>
Date: Thu, 01 May 2014 14:58:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>
CC: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org> <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net> <20140429233950.GE2382@two.firstfloor.org> <53608180.5070800@zytor.com> <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com> <20140501211554.GH2382@two.firstfloor.org>
In-Reply-To: <20140501211554.GH2382@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 02:15 PM, Andi Kleen wrote:
>> If usergs == kernelgs, then ebx will always be 1 and we'll never end
>> up in paranoid_userspace.
> 
> You may miss a reschedule in this obscure case. It shouldn't really
> happen because loading a kernel pointer is not useful for user space.
> 
> Doesn't seem like a real issue to me.
> 
> We only happen need to handle it to avoid crashing.
> 

No, it would be a rootable security hole, not just a crash.

>> Alternatively, what if the paranoid entry checked whether we're coming
>> from userspace at the very beginning and, if so, just jumped to the
>> non-paranoid entry?
> 
> That would work, but I doubt it would be worth it.

If that would solve the problem it is simple enough, but the tricky part
is when we end up in a "crack" where we are in kernel mode with the user GS.

I haven't looked through the flows (I'm at LCE so I have limited screen
bandwidth) to see how that would be handled in this case, but in the
general paranoid case it comes down to the fact that in this particular
subcase we don't necessarily know exactly how many SWAPGS are between us
and userspace after we IRET.

	-hpa


