Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaG2Sqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:46:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaG2Sq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:46:28 -0400
Date: Tue, 29 Jul 2014 20:44:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 6/8] x86: Split syscall_trace_enter into two phases
Message-ID: <20140729184411.GA6035@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <CALCETrWUFo_zXcAZja-vdL4_MgJDd=1ed5Vt54eyUuim930xAw@mail.gmail.com> <20140729165416.GA967@redhat.com> <CALCETrWBU-=zqLTCP7B1feZ9J-e4u-Boic+e1EEn1rL-ijeEKg@mail.gmail.com> <20140729173136.GA2808@redhat.com> <CALCETrVP-P+EJ6YJ=CZL_gyA1r8O9eogUNTik7_31_SA+Pj3pg@mail.gmail.com> <20140729181615.GA4950@redhat.com> <CALCETrVWOOs3HCnQNaqmnn480oQYn3scrWUfR4JJX9+zTxUDRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVWOOs3HCnQNaqmnn480oQYn3scrWUfR4JJX9+zTxUDRw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Andy Lutomirski wrote:
>
> On Tue, Jul 29, 2014 at 11:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 07/29, Andy Lutomirski wrote:
> >>
> >> On Tue, Jul 29, 2014 at 10:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > TIF_NOHZ is set if and only if context_tracking_is_enabled() is true.
> >> > So I think that
> >> >
> >> >         work = current_thread_info()->flags & (_TIF_WORK_SYSCALL_ENTRY & ~TIF_NOHZ);
> >> >
> >> >         user_exit();
> >> >
> >> > looks a bit better. But I won't argue.
> >>
> >> I don't get it.
> >
> > Don't worry, you are not alone.
> >
> >> context_tracking_is_enabled is global, and TIF_NOHZ
> >> is per-task.  Isn't this stuff determined per-task or per-cpu or
> >> something?
> >>
> >> IOW, if one CPU is running something that's very heavily
> >> userspace-oriented and another CPU is doing something syscall- or
> >> sleep-heavy, then shouldn't only the first CPU end up paying the price
> >> of context tracking?
> >
> > Please see another email I sent to Frederic.
> >
> I'll add at least this argument in favor of my approach: if context
> tracking works at all, then it had better not demand that syscall
> entry call user_exit if TIF_NOHZ is *not* set.

I disagree. At least I disagree with that you should enforce this in
syscall_trace_enter() paths, and in any case this has nothing to do with
these changes.

But again, I won't insist, so please forget.

> So adding the
> condition ought to be safe, barring dumb bugs in my code.

Yes, I think it is technically correct.

Oleg.

