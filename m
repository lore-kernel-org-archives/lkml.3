Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3CRST2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:19:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab3CRST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:19:26 -0400
Date: Mon, 18 Mar 2013 18:19:08 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 3/3] ARM: Work around faulty ISAR0 register in some Krait
 CPUs
Message-ID: <20130318181908.GC31193@mudshark.cambridge.arm.com>
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
 <1363138321-27849-4-git-send-email-sboyd@codeaurora.org>
 <20130317142854.GC19071@mudshark.cambridge.arm.com>
 <514748F5.70504@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514748F5.70504@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:03:49PM +0000, Stephen Boyd wrote:
> On 03/17/13 07:28, Will Deacon wrote:
> > On Wed, Mar 13, 2013 at 01:32:01AM +0000, Stephen Boyd wrote:
> >> Some early versions of the Krait CPU design incorrectly indicate
> >> that they only support the UDIV and SDIV instructions in Thumb
> >> mode when they actually support them in ARM and Thumb mode. It
> >> seems that these CPUs follow the DDI0406B ARM ARM which has two
> >> possible values for the divide instructions field, instead of the
> >> DDI0406C document which has three possible values.
> >>
> >> Work around this problem by checking the MIDR against Krait CPUs
> >> with this faulty ISAR0 register and force the detection code
> >> to indicate support in both modes.
> >>
> >> Cc: Will Deacon <will.deacon@arm.com>
> >> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >>  arch/arm/kernel/setup.c | 8 ++++++++
> >>  1 file changed, 8 insertions(+)
> > After all this, you might as well just pass the relevant HWCAPs for your
> > krait entry in proc-v7.S rather than have an exception in the CPU-agnostic
> > code.
> 
> Ok. Care to ack the previous patch I sent then?

Gah, I can't find the original one. If you resend the series with the
changes I suggested in the other mail, I'll add the necessary acks there.

Will
