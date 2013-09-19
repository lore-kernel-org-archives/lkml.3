Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3ISNDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:03:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3ISNDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:03:38 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.LNX.2.00.1309191030180.3014@linux.site>
References: <alpine.LNX.2.00.1309121139000.3818@linux.site> <52322621.3040908@zytor.com> <alpine.LNX.2.00.1309191030180.3014@linux.site>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Resend PATCH 2/2] s390: provide hardware randomness from zcrypt card to /dev/random
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 19 Sep 2013 08:03:11 -0500
To: Torsten Duwe <duwe@lst.de>, Torsten Duwe <duwe@lst.de>
CC: tytso@mit.edu, ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Message-ID: <bddd8f30-4105-4d93-9322-a1ccd9c4b537@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, haveged is... worthy of suspicion (I doubt it is malicious, but still).  Its self-tests are completely useless (replace the entropy source with a constant "1" and they still pass) and there is as far as I know no analysis about the randomness other than "it passes some tests."



Torsten Duwe <duwe@lst.de> wrote:
>
>
>On Thu, 12 Sep 2013, H. Peter Anvin wrote:
>
>> From what I can gather from the patch this is too heavyweight (need
>> locks and so on) to use as arch_get_random*().  There has been a lot
>of
>
>Alas, I can see there's only x86 that currently has this implemented?
>
>> discussion about the pros and cons of allowing the kernel to bypass
>> rngd, but I would think that any such plumbing -- once it gets past
>the
>> fully synchronous low latency properties of arch_get_random*() --
>really
>> should be implemented as an option in the existing hwrng device
>> infrastructure.
>
>As I wrote in the intro, the problem to solve is slow startup when ASLR
>is 
>in effect; in that case: until rngd or haveged is finally running.
>
>> In other words, start by implementing a hwrng device.  That will work
>> right now with rngd running.  Then we can consider if we want to
>allow
>
>That's already there, thanks to the IBM guys :)
>
>> bypass of rngd for certain hwrng devices -- which may include zcrypt,
>> virtio_rng and so on.
>
>I'm currently thinking about some kind of buffer in zcrypt, where 
>arch_get_random can get a long or int quickly, as "designed" after x86.
>Device init or low water would trigger a work item to refill the
>buffer.
>It might tun out though, that every device on every architecture that
>does
>not quite match the x86 approach implements its own buffer.
>
>What do you think?
>
>Besides that, as you wrote, a generic mechanism to mix hwrngs into the 
>input pool would be nice, triggered by user space policy. As far as I
>can 
>see, some mixing of arch_get_random is done, but no entropy credited?
>
>	Torsten

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
