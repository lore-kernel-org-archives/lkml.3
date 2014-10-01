Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaJARvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:51:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42431 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaJARvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:51:00 -0400
Message-ID: <542C3EEB.8050903@zytor.com>
Date: Wed, 01 Oct 2014 10:50:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
CC: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net> <542B2305.9060805@fds-team.de> <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com> <alpine.DEB.2.11.1410010025050.4455@nanos> <CALCETrWTVPjkgfU3sWyKgtfidccXkO=H7y+9XiX20AfeQsAf2w@mail.gmail.com> <alpine.DEB.2.11.1410010119320.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1410010119320.4455@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 04:21 PM, Thomas Gleixner wrote:
>>
>> If we ever want those cycles back, I bet that the compat sysenter path
>> could be trimmed down a lot.  For example, I think that all of the
>> zero-extension stuff is unnecessary now that we have the magic syscall
>> wrappers for all (?) syscalls.
> 
> Emphasis on "(?)". So yes, once we verified that ....
> 

I don't think that's true.  Many system calls use exactly the same entry
point for compat and noncompat calls.  I don't see any value in
replicating that code in every system call.

The only time we need to do anything horribly special is when we have an
argument which is a signed long, which fortunately is not at all common.

	-hpa


