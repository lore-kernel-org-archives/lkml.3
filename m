Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaA3USa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:18:30 -0500
Received: from www84.your-server.de ([213.133.104.84]:35451 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaA3US3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:18:29 -0500
Message-ID: <1391113152.1405.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH 1/4] Make vsyscall_gtod_data handling x86 generic
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Thu, 30 Jan 2014 21:19:12 +0100
In-Reply-To: <CALCETrUvKLwPccVVNpmLwxemAuE4DrmOB0C-jGTBTqcH5zPdCA@mail.gmail.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
	 <1391078953-1575-2-git-send-email-stefani@seibold.net>
	 <CALCETrXqnrDu=rceAm++bGLicj44FfYsxm9-KvqU=B1zkei9TA@mail.gmail.com>
	 <1391110034.945.5.camel@wall-e.seibold.net>
	 <CALCETrUvKLwPccVVNpmLwxemAuE4DrmOB0C-jGTBTqcH5zPdCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.01.2014, 11:51 -0800 schrieb Andy Lutomirski:
> On Thu, Jan 30, 2014 at 11:27 AM, Stefani Seibold <stefani@seibold.net> wrote:
> > Am Donnerstag, den 30.01.2014, 10:05 -0800 schrieb Andy Lutomirski:
> >> On Thu, Jan 30, 2014 at 2:49 AM,  <stefani@seibold.net> wrote:
> >> > diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
> >> > index 59c6c40..45ba688 100644
> >> > --- a/arch/x86/include/asm/compat.h
> >> > +++ b/arch/x86/include/asm/compat.h
> >> > @@ -295,6 +295,10 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
> >> >
> >> >  static inline void __user *arch_compat_alloc_user_space(long len)
> >> >  {
> >> > +#ifdef CONFIG_X86_32
> >> > +       struct pt_regs *regs = task_pt_regs(current);
> >> > +       return (void __user *)regs->sp - len;
> >>
> >> Is there some reason this doesn't need to be aligned?
> >>
> >
> > The reason is that this function will not used for 32 bit kernels, but
> > will the header will be included... This prevents an error!
> 
> Then why not just guard the whole function with an ifdef?  Having a
> piece of actual code that's not intended to be used (and might not
> work) seems like a bad idea.
> 

Good point. I will do this in the next version.


