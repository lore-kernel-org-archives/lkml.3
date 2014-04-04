Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaDDH17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:27:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52311 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaDDH15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:27:57 -0400
Date: Fri, 4 Apr 2014 09:27:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ktap and ebpf integration
Message-ID: <20140404072753.GB1637@gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
 <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> On Thu, Apr 3, 2014 at 6:21 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
> > Hi Alexei,
> >
> > We talked a lot on ktap and ebpf integration in these days,
> > Now I think we can put into deeply to thinking out some
> > technical issues in there.
> >
> > Firstly, I want to make sure you are support this ktap and
> > ebpf integration direction, I aware you have ongoing 'bpf filter'
> > patch set work, which actually overlapping with ktap integration
> > efforts (IMO the interface should be unified and simple for user,
> >  so I think filter debugfs file is not a good interface), so please let
> > me know your answer about this.
> 
> I think the more choices users have the better.
> I'll continue with C based filters and you can continue with ktap
> syntax. That's ok. We can share all kernel pieces.

I'd somewhat agree with that if this wasn't about the kernel, but I 
think that it's evidently useful to have one syntax for the kernel 
(both the scheduler and drivers are written in C) - and probing the 
kernel is really very close to the kernel source itself so it's just 
an extension of that same principle.

Look at the advantages: people who learn how to write C syntax ktaps 
would only be a very small step away from writing actual kernel 
patches and becoming contributors.

With some random weird new syntax (be it Lua, C# or Java or any other 
simplified syntax) that has no relation to kernel source syntax, 
there's no such synergy!

If the 'ktap syntax' lives purely in user space, and the kernel bits 
are largely be shared and reused, which your suggested design is, then 
I have no fundamental objections to that: other than I think it's a 
mistake to not harmonize with the syntax of the probed project! But as 
long as the other desing aspects are fixed it's not a big showstopper 
as the mistake is not propagated to the kernel.

> [ design suggestions ]

I fully agree with your suggestions so far, that looks like a workable 
way to address my concerns.

Thanks,

	Ingo
