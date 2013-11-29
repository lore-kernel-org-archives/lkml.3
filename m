Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3K2VY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:24:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53548 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3K2VYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:24:54 -0500
Message-ID: <529905F9.30703@zytor.com>
Date: Fri, 29 Nov 2013 13:24:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <5298F66A.2010600@zytor.com> <20131129203550.GA14723@redhat.com>
In-Reply-To: <20131129203550.GA14723@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 12:35 PM, Oleg Nesterov wrote:
> On 11/29, H. Peter Anvin wrote:
>>
>> On 11/29/2013 12:05 PM, Oleg Nesterov wrote:
>>>
>>> Can't we invalidate pte (so that any user will stuck in page fault),
>>> update the page(s), restore the pte and drop the locks?
>>
>> That would require a global TLB shootdown
> 
> Well, it is not really global, it is for mm_cpumask() and for good
> reason?
> 
> And is it really worse than on_each_cpu(do_sync_core) and the usage
> of text_mutex?
> 

Probably not, but one would have to consider the total amount of
synchronization needed.

>> (and wouldn't help
>> shared-memory code segments, if we care about that at all.)
> 
> Well, I think this should only support the private mappings.
> 

Well, what do you do if someone tries this on a MAP_SHARED mapping?
Error out?

	-hpa

