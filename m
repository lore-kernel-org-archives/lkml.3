Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIZJZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:25:46 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46113 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaIZJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:25:44 -0400
Date: Fri, 26 Sep 2014 11:25:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
Message-ID: <20140926092539.GA9649@gmail.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-3-git-send-email-minipli@googlemail.com>
 <541F2BCD.2040007@linux.intel.com>
 <CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
 <20140924074555.GA3797@gmail.com>
 <CA+rthh9HRMg0E3gE11F+KSdyMpjYC6d=gZhcu5-1TDqMfAw3Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh9HRMg0E3gE11F+KSdyMpjYC6d=gZhcu5-1TDqMfAw3Uw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathias Krause <minipli@googlemail.com> wrote:

> On 24 September 2014 09:45, Ingo Molnar <mingo@kernel.org> wrote:
> > * Mathias Krause <minipli@googlemail.com> wrote:
> >> On 21 September 2014 21:49, Arjan van de Ven <arjan@linux.intel.com> wrote:
> >> > On 9/21/2014 8:26 AM, Mathias Krause wrote:
> >> >>
> >> >> -               if (pr & _PAGE_PCD)
> >> >> -                       pt_dump_cont_printf(m, dmsg, "PCD ");
> >> >> -               else
> >> >> -                       pt_dump_cont_printf(m, dmsg, "    ");
> >> >> +               pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" :
> >> >> "");
> >> >
> >> >
> >> > while you have some nice cleanups in your patch, I can't say I consider this
> >> > an improvement.
> >> > Yes the C standard allows ? to be used like this
> >> > but no, I don't think it improves readability in general.
> >>
> >> Not in general, but in this case, it does, IMHO.
> >>
> >> > (I think for me the main exception is NULL pointer cases, but this is not
> >> > one of these)
> >>
> >> Apparently such a pattern (using the question mark operator combined
> >> with a bit test to choose string constants) is used quite often in the
> >> linux kernel as a simple grep tells me (probably catches a few false
> >> positives but still a representative number):
> >
> > Both can be used (although I too find the original version easier
> > to read), and it's usually the taste/opinion of the original
> > author whose choice we prefer.
> 
> So I should start writing more code from the scratch than changing
> others... ;)
> 
> But concerning this patch, are you interested in the following other
> pieces:
> - changing the macros from being a compound statement expression to
>   the common 'do .. while(0)' pattern
> - use of pr_info()/pr_cont() instead of printk(KERN_INFO/KERN_CONT)
> - use of format strings in pt_dump_cont_printf() calls
> - removing the trailing blank before '\n' in the "... # entries
>   skipped ..." message
> ...or should I just drop patch 2 altogether?

Honestly? I'm not interested at all in self-centered make-work 
cleanups that don't really improve the code materially - I'm more 
interested in cleanups that are a side effect of real work and 
real interest.

There's literally 1 million checkpatch 'failures' in the kernel 
source code, do we really want to clean them all up, waste 
reviewer and maintainer bandwidth and pretend that those 1 
million extra cleanup commits are just as valuable as the 'other' 
work that goes on in the kernel?

Why don't you do something different: for example something 
functionally useful (some real improvements to the code!), and 
make sure it's all clean while you are doing it? That gives an 
opportunity to clean up anything that your changes touch as well. 

We always welcome cleanups that are a side effect of feature 
work. Cleanups for code that is perfectly readable, just for 
cleanup's sake, is counterproductive ...

Doing printk() formatting fixes is fine for a newbie, but as I 
told Perches a couple of times already, and as I told Bunk before 
him, most kernel developers grow beyond printk() fixes after 
their first few commits.

Thanks,

	Ingo
