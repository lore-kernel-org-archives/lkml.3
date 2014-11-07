Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaKGQi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:38:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48593 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaKGQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:38:54 -0500
Date: Fri, 7 Nov 2014 16:38:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: Copy register_persistent_clock() to arm64
 source subtree
Message-ID: <20141107163836.GB5586@leverpostej>
References: <1415319665-21701-1-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmXDqhwCk1pRf_9yGycboMqt-ZE33y=kZrhbqXOjVcrxYQ@mail.gmail.com>
 <545C4783.8070506@nvidia.com>
 <20141107104025.GC4585@leverpostej>
 <CAOMFOmWfgtN+Q-sbQUS8-90pTrtk5Du8xkDVXaed=teVPb8sbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmWfgtN+Q-sbQUS8-90pTrtk5Du8xkDVXaed=teVPb8sbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:24:19PM +0000, Anatol Pomozov wrote:
> Hi
> 
> On Fri, Nov 7, 2014 at 2:40 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Nov 07, 2014 at 04:16:03AM +0000, Stephen Warren wrote:
> >> On 11/06/2014 05:25 PM, Anatol Pomozov wrote:
> >> > +Stephen
> >> >
> >> > This patch is for tegra20_timer that uses register_persistent_clock().
> >> > I did not find any way to share the same arch code for arm/arm64.
> >> >
> >> > Actually this register_persistent_clock() does not look arm specific
> >> > at all. Would it be better to move it somewhere outside of arch/?
> >>
> >> No CC to linux-tegra@ or the other Tegra maintainers?
> >>
> >> Yes, I think it'd be best not to have arch-specific APIs, or cut/paste
> >> the same code into multiple places.
> >
> > Agreed. This looks in no way architecture specific, and having this in
> > common code would be preferable to copying.
> 
> Where the code common for arm and arm64 should go?
> drivers/???/arm_timekeeping.c ?

I'd argue that this is in no way specific to ARM, and the current weak
functions live in kernel/time/timekeeping.c, so this should too.

Thanks,
Mark.
