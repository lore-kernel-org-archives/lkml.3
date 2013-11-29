Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3K2UFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:05:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab3K2UE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:04:57 -0500
Date: Fri, 29 Nov 2013 21:05:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131129200532.GA13561@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129195419.GB17656@two.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Andi Kleen wrote:
>
> > Andi, et al. I am going to discuss the things I do not really
> > understand, probably this can't make any sense, but...
>
> I think it's enough to set the dirty bit in the underlying
> struct page, no need to play games with the PTE.

Ah, sorry for confusion, I guess you misunderstood.

I meant, perhaps sys_text_poke() doesn't the in-kernel text_poke
machinery altogether?

Can't we invalidate pte (so that any user will stuck in page fault),
update the page(s), restore the pte and drop the locks?

This way sys_text_poke() won't be x86-specific, and it will be per-mm.

Oleg.

