Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3LESqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:46:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab3LESqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:46:02 -0500
Date: Thu, 5 Dec 2013 19:45:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131205184550.GA28159@redhat.com>
References: <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com> <20131204111125.GA26552@redhat.com> <529F51D9.7010001@zytor.com> <20131204164817.GA5271@redhat.com> <529F5E47.3040108@zytor.com> <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com> <20131204174328.GA8082@redhat.com> <20131205172355.GA25780@redhat.com> <20131205174923.GE14407@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205174923.GE14407@pd.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Borislav Petkov wrote:
>
> On Thu, Dec 05, 2013 at 06:23:55PM +0100, Oleg Nesterov wrote:
> > This is almost off-topic, but I am wondering if (in the long term) we
> > can avoid this "insert the bp into every mm" altogether.
> >
> > Instead, uprobe_write_opcode() should only unmap this page and set
>
> Ok, sorry if I'm completely off base here but have you guys tried
> unmapping the page from all other VMs,

This is what I meant, but we can't simply clear this pte,

> and causing all
> the VMs to refault

why? it would be better to install the page on demand.

> patching you'd probably need to cause the #PF handler to "loop" until
> patching is complete though.

We can't do this, but I do not think we need to block #PF handler.

However, somehow the #PF handler should know that it should install
the patched page owned by uprobes. That is why I talked about
SWP_UPROBE_ENTRY (or something similar)

But again, in any case this is not trivial.

And perhaps I misundestood you... If you actually want to cause
all the VMs to refault, then why we can't unmap + refault every
mm like the patch I sent does? Just in case, note that we can't
share the same page anyway without more complications.

Oleg.

