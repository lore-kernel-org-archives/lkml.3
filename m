Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937176Ab3DJR6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:58:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33335 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934904Ab3DJR6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:58:23 -0400
Message-ID: <5165A82E.8000609@zytor.com>
Date: Wed, 10 Apr 2013 10:58:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Russ Anderson <rja@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
References: <20130403193743.GB29151@sgi.com> <20130408155701.GB19974@gmail.com> <5162EC1A.4050204@zytor.com> <20130408165916.GA3672@sgi.com> <20130410111620.GB29752@gmail.com> <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com> <20130410152911.GA3011@sgi.com> <20130410165934.GB21951@gmail.com>
In-Reply-To: <20130410165934.GB21951@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 09:59 AM, Ingo Molnar wrote:
> 
> 4 minutes bootup is 240 seconds, with 1024 CPUs that's about 240 msecs per CPU.
> 
> That sounds a lot, given that unlike bootup there's not much real work to be done 
> during shutdown - we don't initialize anything, etc.
> 
> Maybe much of those 240 msecs are spent in some stupid udelay loop or so, which 
> could be made parallel?
> 

I wonder if it isn't calling stop_machine() 1024 times, each time
rendezvousing all the still-active CPUs.

	-hpa


