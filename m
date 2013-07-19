Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab3GSBus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:50:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3GSBur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:50:47 -0400
Date: Thu, 18 Jul 2013 18:50:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: PaX Team <pageexec@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86: Make sure IDT is page aligned
Message-ID: <20130719015055.GA16577@kroah.com>
References: <20130719011526.15FA46608B1@gitolite.kernel.org>
 <20130719013011.GA2446@kroah.com>
 <CAGXu5jKF9Ds6Mjs2knPqh2V5KH0Ahr97geip8xosp_5m=3hB4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKF9Ds6Mjs2knPqh2V5KH0Ahr97geip8xosp_5m=3hB4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 06:36:07PM -0700, Kees Cook wrote:
> On Thu, Jul 18, 2013 at 6:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jul 19, 2013 at 01:15:26AM +0000, Linux Kernel Mailing List wrote:
> >> Gitweb:     http://git.kernel.org/linus/;a=commit;h=4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> >> Commit:     4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> >> Parent:     5ff560fd48d5b3d82fa0c3aff625c9da1a301911
> >> Author:     Kees Cook <keescook@chromium.org>
> >> AuthorDate: Tue Jul 16 11:34:41 2013 -0700
> >> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> >> CommitDate: Tue Jul 16 15:14:48 2013 -0700
> >>
> >>     x86: Make sure IDT is page aligned
> >>
> >>     Since the IDT is referenced from a fixmap, make sure it is page aligned.
> >>     Merge with 32-bit one, since it was already aligned to deal with F00F
> >>     bug. Since bss is cleared before IDT setup, it can live there. This also
> >>     moves the other *_idt_table variables into common locations.
> >>
> >>     This avoids the risk of the IDT ever being moved in the bss and having
> >>     the mapping be offset, resulting in calling incorrect handlers. In the
> >>     current upstream kernel this is not a manifested bug, but heavily patched
> >>     kernels (such as those using the PaX patch series) did encounter this bug.
> >>
> >>     The tables other than idt_table technically do not need to be page
> >>     aligned, at least not at the current time, but using a common
> >>     declaration avoids mistakes.  On 64 bits the table is exactly one page
> >>     long, anyway.
> >>
> >>     Signed-off-by: Kees Cook <keescook@chromium.org>
> >>     Link: http://lkml.kernel.org/r/20130716183441.GA14232@www.outflux.net
> >>     Reported-by: PaX Team <pageexec@gmail.com>
> >>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >> ---
> >>  arch/x86/kernel/head_64.S    |   15 ---------------
> >>  arch/x86/kernel/tracepoint.c |    6 ++----
> >>  arch/x86/kernel/traps.c      |   12 ++++++------
> >>  3 files changed, 8 insertions(+), 25 deletions(-)
> >
> > This patch is now in Linus's tree.  Kees, did you also want this in the
> > -stable tree(s)?
> 
> The potential problem was introduced with
> 4eefbe792baedb474e256d35370849992fcf1c79, so 3.10 needs it, yes. I had
> also sent a much smaller version here:
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=idt-stable&id=794c1e0df641e13050cfc4af340fc3c85bed4ea3
> 
> Either will address the problem. If there is no problem with taking
> the larger clean-up for stable, then that's probably easiest.

I'd prefer to stick with what ended up in Linus's tree, so I'll just
queue this one up in a future stable 3.10 release, thanks.

greg k-h
