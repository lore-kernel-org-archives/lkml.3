Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3BQWuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:50:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55430 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab3BQWuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:50:54 -0500
Message-ID: <51215E6C.5090102@zytor.com>
Date: Sun, 17 Feb 2013 14:49:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
References: <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils> <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com> <20130215174435.GA2792@linux.vnet.ibm.com> <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com> <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com> <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com> <20130216192554.GB7035@linux.vnet.ibm.com> <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
In-Reply-To: <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 11:46 AM, Linus Torvalds wrote:
> Adding Peter Anvin to the people, just in case he sees what's wrong
> with the system call stub generation that keeps excessively old object
> files around. If it's easy to fix, it might be worth trying to make it
> ok to switch from i386 to x86-64 and back in the same tree.

I have not been able to reproduce this; it seems to Just Work[TM].

The syscall header stuff is definitely not to blame: it doesn't even 
*see* the CONFIG_ settings; instead they are only used to determine 
which subset of files to create, but the files themselves are 
configuration-independent.  This is by design.

As such, without an actual known to fail test case there isn't much I 
can do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

