Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaDDHsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:48:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65451 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaDDHsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:48:04 -0400
Date: Fri, 4 Apr 2014 09:48:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ktap and ebpf integration
Message-ID: <20140404074800.GD1637@gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
 <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
 <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> On Fri, Apr 4, 2014 at 2:26 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> > On Thu, Apr 3, 2014 at 6:21 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> >> Hi Alexei,
> >>
> >> We talked a lot on ktap and ebpf integration in these days,
> >> Now I think we can put into deeply to thinking out some
> >> technical issues in there.
> >>
> >> Firstly, I want to make sure you are support this ktap and
> >> ebpf integration direction, I aware you have ongoing 'bpf filter'
> >> patch set work, which actually overlapping with ktap integration
> >> efforts (IMO the interface should be unified and simple for user,
> >>  so I think filter debugfs file is not a good interface), so please let
> >> me know your answer about this.
> >
> > I think the more choices users have the better.
> > I'll continue with C based filters and you can continue with ktap
> > syntax. That's ok. We can share all kernel pieces.
> 
> Now I understand that there is no way to integrate ktap and ibpf in 
> technical point of view, the kernel side and interface is completely 
> different, and obviously you don't want to change current per-event 
> filter file based interface and kernel part, that make impossible to 
> let ktap could integrate or share with ibpf.

In my reading that's not what Alexei wrote: he just suggested that as 
long as the kernel bits are largely shared, the user-space bits 
(syntax, etc.) can stay completely orthogonal and independent.

It also does not mean that ktap is forced to use the per event filter 
file based interface to pass BPF scripts to the kernel. BPF is already 
used by various facilities in the kernel, with different user-space 
APIs to interface with it.

So the main technical question is: why should ktap have its own 
separate in-kernel code execution engine, if we already have the BPF 
virtual machine (which is well-maintained, has excellent performance 
through JIT, etc.), which could be reused and/or enhanced?

Is there any aspect of ktap's virtual machine that BPF does not have?

Thanks,

	Ingo
