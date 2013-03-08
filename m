Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab3CHGmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:42:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32809 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab3CHGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:42:16 -0500
Date: Fri, 8 Mar 2013 06:41:39 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: proc: Add Krait proc info
Message-ID: <20130308064139.GA31156@mudshark.cambridge.arm.com>
References: <1362439299-29617-1-git-send-email-sboyd@codeaurora.org>
 <20130305083421.GA19391@mudshark.cambridge.arm.com>
 <51366B9E.7010502@codeaurora.org>
 <5136D220.5090904@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5136D220.5090904@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:20:32AM +0000, Stephen Boyd wrote:
> On 03/05/13 14:03, Stephen Boyd wrote:
> > On 03/05/13 00:34, Will Deacon wrote:
> >> I was looking at this the other day and wondered whether we could set
> >> HWCAP_IDIV in __v7_setup, depending on ID_ISAR0[27:24]. I can't immediately
> >> think why that would be difficult, but similarly there may well be a reason
> >> why we assign it like this.
> >>
> >> Fancy taking a look?
> > Ok I'll take a look. 
> 
> Hmm. I wonder if we did it this way because between version B and C of
> DDI0406 the definition of those bits changed.
> 
> In DDI0406B we have
> 
>     0 - no support
>     1 - support
> 
> and in DDI0406C we have
> 
>     0 - no support
>     1 - support in Thumb
>     2 - support in Thumb and ARM

Well spotted, although I think this a documentation error. I've checked both
A7 and A15 and they both advertise '2' (although r0p0 TRM for A7 also gets
this wrong, the CPU does the right thing).

What about the Qualcomm CPUs?

Will
