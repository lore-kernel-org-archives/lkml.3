Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaALRqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:46:14 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58842 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaALRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:46:11 -0500
Date: Sun, 12 Jan 2014 18:46:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
Message-ID: <20140112174607.GA26698@gmail.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
 <20131224204625.GB20471@gmail.com>
 <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
 <52BD199A.8070607@zytor.com>
 <52BE0D89.3080405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BE0D89.3080405@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/26/2013 10:09 PM, H. Peter Anvin wrote:
> > On 12/26/2013 11:00 AM, Linus Torvalds wrote:
> >>
> >> Interestingly, looking at the cp_new_stat() profiles, the games we
> >> play to get efficient range checking seem to actually hurt us. Maybe
> >> it's the "sbb" that is just expensive, or maybe it's turning a (very
> >> predictable) conditional branch into a data dependency chain instead.
> >> Or maybe it's just random noise in my profiles that happened to make
> >> those sbb's look bad.
> >>
> > 
> > Much to my surprise, this patch adds almost 10K of text to an 
> > "allyesconfig" build.  I wouldn't have expected it.  I'll look at 
> > it some more tomorrow.
> 
> Mystery solved... it is all code added by gcov &c because a new 
> (inline) function is added to the code base.  So it is fluff, not 
> real.

Yeah, defconfig builds are better for size comparisons, at least on 
x86 they are distro-config derived so a lot more relevant to real life 
than allyesconfig or allmodconfig.

Thanks,

	Ingo
