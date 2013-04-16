Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3DPMK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:10:58 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:46362 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3DPMK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:10:56 -0400
Message-ID: <516D3FCD.9060703@hp.com>
Date: Tue, 16 Apr 2013 08:10:53 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 optional 3/3] mutex: back out architecture specific
 check for negative mutex count
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com> <1366036679-9702-4-git-send-email-Waiman.Long@hp.com> <20130416100505.GD31156@mudshark.cambridge.arm.com>
In-Reply-To: <20130416100505.GD31156@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 06:05 AM, Will Deacon wrote:
> On Mon, Apr 15, 2013 at 03:37:59PM +0100, Waiman Long wrote:
>> If it is confirmed that all the supported architectures can allow a
>> negative mutex count without incorrect behavior, we can then back
>> out the architecture specific change and allow the mutex count to
>> go to any negative number. That should further reduce contention for
>> non-x86 architecture.
>>
>> If this is not the case, this patch should be dropped.
> A good starting point might be to look at the asm-generic mutex
> implementations, which clears up the majority of architectures. A cursory
> glance at mutex-dec.h suggests that it's OK to me...

I think the generic version is fine with negative mutex count. However, 
it is the architecture specific versions (we have 22 of them as of 3.8) 
that I am worry about. I just don't have enough know-how and test 
machines to verify that.

Regards,
Longman
