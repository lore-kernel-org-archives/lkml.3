Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaDWRI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:08:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62362 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbaDWRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:08:54 -0400
Date: Wed, 23 Apr 2014 18:08:21 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Message-ID: <20140423170821.GJ5649@arm.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:31:09AM +0100, Neil Zhang wrote:
> 
> > -----Original Message-----
> > From: Will Deacon [mailto:will.deacon@arm.com]
> > Sent: 2014年4月22日 18:37
> > To: Neil Zhang
> > Cc: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org; Sudeep Holla; devicetree@vger.kernel.org
> > Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
> > 
> > Hi Neil,
> > 
> > On Tue, Apr 22, 2014 at 03:26:36AM +0100, Neil Zhang wrote:
> > > This adds core support for saving and restoring CPU PMU registers for
> > > suspend/resume support i.e. deeper C-states in cpuidle terms.
> > > This patch adds support only to ARMv7 PMU registers save/restore.
> > > It needs to be extended to xscale and ARMv6 if needed.
> > >
> > > I made this patch because DS-5 is not working on Marvell's CA7 based SoCs.
> > > And it has consulted Sudeep KarkadaNagesha's patch set for multiple PMUs.
> > >
> > > Thanks Will and Sudeep's suggestion to only save / restore used events.
> > 
> > Whilst this is a step in the right direction, I'd still like to see the save/restore
> > predicated on something in the device-tree or otherwise. Most SoCs *don't*
> > require these registers to be preserved by software, so we need a way to
> > describe that the PMU is in a power-domain where its state is lost when the
> > CPU goes idle.
> > 
> > This doesn't sound like a PMU-specific problem, so there's a possibility that
> > this has been discussed elsewhere, in the context of other IP blocks
> > 
> > [adding the devicetree list in case somebody there is aware of any work in
> > this area]
> > 
> 
> Thanks Will.
> What should I do now?
> Add a filed under PMU or waiting for somebody whether there are general
> supporting for power domain maintain.

I think we need some input from the device-tree guys to see whether they
would object to us solving this locally (in the PMU node) or not.
Personally, I'd much prefer a general way to describe the need for
pm-notifiers, but if that's not being looked at then we can cook something
specifically for our needs.

Will
