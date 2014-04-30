Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaD3Ewm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:52:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaD3Ewl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:52:41 -0400
Message-ID: <53608180.5070800@zytor.com>
Date: Tue, 29 Apr 2014 21:52:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org> <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net> <20140429233950.GE2382@two.firstfloor.org>
In-Reply-To: <20140429233950.GE2382@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:39 PM, Andi Kleen wrote:
>> Case 3 is annoying.  If nothing tries to change the user gs base, then
>> everything is okay because the user gs base and the kernel gs bases are
>> equal.  But if something does try to change the user gs base, then it
>> will accidentally change the kernel gs base instead.
> 
> It doesn't really matter, as they are the same.
> They would just switch identities.
> 
> Besides I don't think anyone does that.
> 

It matters -- greatly -- if (and only if) we can enter the kernel with
usergs == kernelgs and then want to change usergs inside a paranoid
routine.  At that point we risk being upside down, which basically means
we're rooted.

However, I believe this patchset also means only IST entries can be
paranoid, which in turn means we can't sleep inside them.  To the very
best of my knowledge the only times we change usergs is on context
switch or inside a system call.  We need to make sure that is actually
the case, though.

I'm at ELC for a few days, so I'll have limited decent-sized-monitor
time, but it shouldn't be too hard to convince ourselves of... mostly a
matter of making sure something like ptrace can't to stupid crap.

	-hpa


