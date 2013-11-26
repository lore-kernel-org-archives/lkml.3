Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab3KZTF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:05:57 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53135 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3KZTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:05:54 -0500
Message-ID: <5294F10C.8060901@amacapital.net>
Date: Tue, 26 Nov 2013 11:05:48 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:37 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> [Addressed all addressable review feedback in v2]
> 
> Properly patching running code ("cross modification")
> is a quite complicated business on x86.
> 
> The CPU has specific rules that need to be followed, including
> multiple global barriers.
> 
> Self modifying code is getting more popular, so it's important
> to make it easy to follow the rules.
> 
> The kernel does it properly with text_poke_bp(). But the same
> method is hard to do for user programs.
> 
> This patch adds a (x86 specific) text_poke() syscall that exposes
> the text_poke_bp() machinery to user programs.
> 
> The interface is practically the same as text_poke_bp, just as
> a syscall. I added an extra flags parameter, for future
> extension.  Right now it is enforced to be 0.
> 
> The call also still has a global lock, so it has some scaling
> limitations. If it was commonly used this could be fixed
> by setting up a list of break point locations. Then
> a lock would only be hold to modify the list.
> 
> Right now the implementation is just as simple as possible.

IIRC someone proposed that, rather than specifying a "handler", that any
user thread that traps just wait until the poke completes.  This would
complicate the kernel implementation a bit, but it would make the user
code a good deal simpler.  Is there any reason that this is a bad idea?

--Andy
