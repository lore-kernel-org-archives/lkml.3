Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3IKQBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:01:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53051 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab3IKQBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:01:48 -0400
Message-ID: <5230939E.3050408@zytor.com>
Date: Wed, 11 Sep 2013 09:00:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
References: <20130910130811.507933095@infradead.org> <20130910135152.GD7537@gmail.com> <20130910135636.GA8268@gmail.com> <522F3ACC.9000701@linux.intel.com> <CA+55aFz3S6_g4TQ11VKGM3GW=a=r3qYWQ_a0qJ_5241qQz8D=w@mail.gmail.com>
In-Reply-To: <CA+55aFz3S6_g4TQ11VKGM3GW=a=r3qYWQ_a0qJ_5241qQz8D=w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 09:24 AM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 8:29 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>>
>> also.. yuck on using "dec"
>> "dec" sucks, please use "sub foo  ,1" instead
> 
> That's a bigger instruction, largely due to the constant.
> 
>> (dec sucks because of its broken flags behavior; it creates basically a
>> bubble in the pipeline)
> 
> Intel could (and should) just fix that. It's "easy" enough - you just
> need to rename the carry flag as a separate register (and make sure
> that the conditional instructions that don't use it don't think they
> need it).
> 
> In fact I thought Intel already did that on their large cores. Are you
> sure they still have trouble with inc/dec?
> 

Big cores are fine, but Atom (and presumably Quark) might still suffer a
performance penalty.

	-hpa


