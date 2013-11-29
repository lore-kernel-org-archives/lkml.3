Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3K2StM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:49:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54165 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab3K2StI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:49:08 -0500
Date: Fri, 29 Nov 2013 18:48:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V5 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131129184824.GA6730@mudshark.cambridge.arm.com>
References: <1385372753-7396-1-git-send-email-vkale@apm.com>
 <1385372753-7396-3-git-send-email-vkale@apm.com>
 <20131125184159.GE28201@mudshark.cambridge.arm.com>
 <CAPrCYkfThbf4GoPrWB=CrnY6SfnaksxiDwqgqevYXdnrH-ynjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPrCYkfThbf4GoPrWB=CrnY6SfnaksxiDwqgqevYXdnrH-ynjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 08:44:24AM +0000, Vinayak Kale wrote:
> On Tue, Nov 26, 2013 at 12:11 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Nov 25, 2013 at 09:45:53AM +0000, Vinayak Kale wrote:
> >> +static void
> >> +armpmu_enable_percpu_irq(void *data)
> >> +{
> >> +     struct arm_pmu *armpmu = data;
> >> +     struct platform_device *pmu_device = armpmu->plat_device;
> >> +     int irq = platform_get_irq(pmu_device, 0);
> >> +
> >> +     enable_percpu_irq(irq, 0);
> >
> > IRQ_TYPE_NONE?
> 
> Did you mean to use macro instead or 0? If yes, I will modify.

Yes.

Will
