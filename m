Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3K2USc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:18:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3K2USb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:18:31 -0500
Message-ID: <5298F66A.2010600@zytor.com>
Date: Fri, 29 Nov 2013 12:17:46 -0800
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
> 
> Can't we invalidate pte (so that any user will stuck in page fault),
> update the page(s), restore the pte and drop the locks?
> 

That would require a global TLB shootdown (and wouldn't help
shared-memory code segments, if we care about that at all.)  It also
means much bigger code ranges would be affected.

The performance requirements are part of what makes the INT3 solution
attractive, but anything is going to inherently be slow.

> This way sys_text_poke() won't be x86-specific, and it will be per-mm.

That is definitely an appeal.

	-hpa


