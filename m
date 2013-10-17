Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3JQJ1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab3JQJ1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:27:44 -0400
Date: Thu, 17 Oct 2013 12:27:27 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
Message-ID: <20131017092727.GN15657@redhat.com>
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
 <525ECEA102000078000FB906@nat28.tlf.novell.com>
 <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
 <525ED75402000078000FB95B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525ED75402000078000FB95B@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 05:13:40PM +0100, Jan Beulich wrote:
> > It preserves *less* state, because the upper 32 bits of rip are now
> > corrupted. Any 64-bit application that actually looks at the FP
> > rip/rdp fields now get the WRONG VALUES.
> 
> But again - this isn't being done for ordinary 64-bit applications,
> this is only happening for KVM guests. And there not being a
> protocol for telling the caller whether a certain context hold
> 64-bit offsets or selector/offset pairs shouldn't be a reason to
> think of a solution to the problem.
> 
KVM knows what mode guest vcpu is in. is_long_mode(vcpu) will tell you
if it is in long mode or not. No need to guess it.

--
			Gleb.
