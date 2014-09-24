Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaIXHqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:46:01 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36588 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIXHqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:46:00 -0400
Date: Wed, 24 Sep 2014 09:45:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
Message-ID: <20140924074555.GA3797@gmail.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-3-git-send-email-minipli@googlemail.com>
 <541F2BCD.2040007@linux.intel.com>
 <CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathias Krause <minipli@googlemail.com> wrote:

> On 21 September 2014 21:49, Arjan van de Ven <arjan@linux.intel.com> wrote:
> > On 9/21/2014 8:26 AM, Mathias Krause wrote:
> >>
> >> -               if (pr & _PAGE_PCD)
> >> -                       pt_dump_cont_printf(m, dmsg, "PCD ");
> >> -               else
> >> -                       pt_dump_cont_printf(m, dmsg, "    ");
> >> +               pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" :
> >> "");
> >
> >
> > while you have some nice cleanups in your patch, I can't say I consider this
> > an improvement.
> > Yes the C standard allows ? to be used like this
> > but no, I don't think it improves readability in general.
> 
> Not in general, but in this case, it does, IMHO.
> 
> > (I think for me the main exception is NULL pointer cases, but this is not
> > one of these)
> 
> Apparently such a pattern (using the question mark operator combined
> with a bit test to choose string constants) is used quite often in the
> linux kernel as a simple grep tells me (probably catches a few false
> positives but still a representative number):

Both can be used (although I too find the original version easier 
to read), and it's usually the taste/opinion of the original 
author whose choice we prefer.

Thanks,

	Ingo
