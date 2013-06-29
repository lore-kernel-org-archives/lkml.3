Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3F2QlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 12:41:01 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49858 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3F2Qk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 12:40:58 -0400
Date: Sat, 29 Jun 2013 09:40:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dawnchen@google.com, Paul Turner <pjt@google.com>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130629164051.GA32299@mtj.dyndns.org>
References: <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <CAAAKZws1qkSik4G4pRr7z+067Jp9-jHfpx9-euqbvmdHjoN_Zg@mail.gmail.com>
 <20130627010427.GF4536@htj.dyndns.org>
 <CAAAKZwsMT7FRccyVxSn77GR8+9JsSeqmDO6oOy7ycNCY7Desnw@mail.gmail.com>
 <20130627173809.GB5599@mtj.dyndns.org>
 <CAAAKZwvabGRsce43ymru7OBr0LX93DRnTVkzn-nhahTR6yMUZw@mail.gmail.com>
 <20130627210445.GA22860@mtj.dyndns.org>
 <CAAAKZwtOnpATCmRcOpsXaLZ8sQDs2Z=iZb8FrqG=bajNAOBnRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwtOnpATCmRcOpsXaLZ8sQDs2Z=iZb8FrqG=bajNAOBnRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tim.

On Fri, Jun 28, 2013 at 11:44:23AM -0700, Tim Hockin wrote:
> I totally understand where you're coming from - trying to get back to
> a stable feature set.  But it sucks to be on the losing end of that

Oh, it has been sucking and will continue to suck like hell for me too
for the foreseeable future.  Trust me, this side ain't any greener.

> battle - you're cutting things that REALLY matter to us, and without a
> really viable alternative.  So we'll keep fighting.

Yeah, that's understandable.  More on this later.

> Splitting threads is sort of important for some cgroups, like CPU.  I
> wonder if pjt is paying attention to this thread.

Paul?

> I think this is wrong.  Take the opportunity to define the RIGHT
> interface that you WANT - a container.  Implement it in terms of
> cgroups (and maybe other stuff!).  Make that API so compelling that
> people want to use it, and your war of attrition on direct cgroup
> madness will be won, but with net progress rather than regress.

The goal is to reach sane and widely useable / useful state with
minimum amount of complexity.  Maintaining backward compatibility for
some period - likely quite a few years - while still allowing future
development is a pretty important consideration.  Another factor is
that the general situation has been more or less atrocious and cgroup
as a whole has been failing in the very basic places, which also
reinforces the drive for simplicity.

I probably am forgetting some, but anyways, from my POV, there are
fairly strong by-default factors which push for simplicity even if
that means some loss of functionalities as long as those aren't
something catastrophic.  I've been going over the decisions past few
days and unified hierarchy still seems the best, or rather, most
acceptable solution.

That said, I stil don't know very well the scope and severity of the
problems you guys might face from the loss of multiple orthogonal
hierarchies.  The cpuset one wasn't very convincing especially given
that most of expressibility problems can be mitigated if you presume
the central managing facility which can adapt the configurations as
the workload changes.  Dynamic execution of configuration of course is
the job of cgroup proper but larger cadence changes doesn't have to be
statically encoded in the hierarchy itself and as I wrote before some
just can't be whether multiple hierarchy or not.

While the bar to overcome is pretty high, I do want to learn about the
problems you guys are foreseeing, so that I can at least evaulate the
graveness properly and hopefully compromises which can mitigate the
most sore ones can be made wherever necessary.

So, can you please explain the issues that you've experienced and are
foreseeing in detail with their contexts?  ie. if you have certain
requirement, please give at least brief explanation on where such
requirement is coming from and how important the requirement is.

Thanks.

-- 
tejun
