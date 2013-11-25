Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KYKNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:13:38 -0500
Received: from smtp.citrix.com ([66.165.176.89]:39266 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab3KYKNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:13:36 -0500
X-IronPort-AV: E=Sophos;i="4.93,766,1378857600"; 
   d="scan'208";a="77773268"
Message-ID: <1385374413.11161.28.camel@kazak.uk.xensource.com>
Subject: Re: IRQF_RESUME_EARLY and errors in dpm_suspend_noirq
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 25 Nov 2013 10:13:33 +0000
In-Reply-To: <528C86C2.1070206@nvidia.com>
References: <201311201020.08158.heiko@sntech.de>
	 <528C86C2.1070206@nvidia.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 15:24 +0530, Laxman Dewangan wrote:
> On Wednesday 20 November 2013 02:50 PM, Heiko Stübner wrote:
> > Hi,
> >
> > Commit 9bab0b7fbace (genirq: Add IRQF_RESUME_EARLY and resume such IRQs
> > earlier) split the suspend/resume of the irqs into two parts.
> >
> > The early-irqs get resumed during syscore_resume, while the rest get
> > resumed by the regular resume_device_irqs.
> >
> > I may be blind, but where get the early-irqs resumed in the error
> > path of dpm_suspend_noirq?
> >
> > When a suspend_noirq callback returns an error, dpm_resume_noirq gets called,
> > which only calls resume_device_irqs while the suspend_device_irqs call in
> > dpm_suspend_noirq suspends all irqs. So it does not seem that the early-irqs
> > get resumed at all in this case.
> >
> I also faced same issue in our suspend failure path and posted fix 
> sometime ago as
> https://lkml.org/lkml/2013/8/13/373
> 
> It is still under review.

IME zero comments since August is not "under review", it is "has slipped
through the cracks" ;-)

I would suggest you resend it.

Ian.

