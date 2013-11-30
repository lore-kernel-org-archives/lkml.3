Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3K3FRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 00:17:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56586 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3K3FRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 00:17:54 -0500
Message-ID: <529974C9.6040607@zytor.com>
Date: Fri, 29 Nov 2013 21:16:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com>
In-Reply-To: <20131129200532.GA13561@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 12:05 PM, Oleg Nesterov wrote:
> On 11/29, Andi Kleen wrote:
>>
>>> Andi, et al. I am going to discuss the things I do not really
>>> understand, probably this can't make any sense, but...
>>
>> I think it's enough to set the dirty bit in the underlying
>> struct page, no need to play games with the PTE.
> 
> Ah, sorry for confusion, I guess you misunderstood.
> 
> I meant, perhaps sys_text_poke() doesn't the in-kernel text_poke
> machinery altogether?
> 
> Can't we invalidate pte (so that any user will stuck in page fault),
> update the page(s), restore the pte and drop the locks?
> 
> This way sys_text_poke() won't be x86-specific, and it will be per-mm.
> 

Hmmm... if we hold mmap_sem() this pretty much will be the net result,
no?  That would mean no additional tests needed on the page fault path.
 What I'm not sure of is whether or not it is actually safe to hold
mmap_sem across all the code we need -- on the other hand, we may very
well need to do so.

	-hpa


