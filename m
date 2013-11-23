Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3KWV0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 16:26:16 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39484 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KWV0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 16:26:14 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: IRQF_RESUME_EARLY and errors in dpm_suspend_noirq
Date: Sat, 23 Nov 2013 22:25:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Ian Campbell <ian.campbell@citrix.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
References: <201311201020.08158.heiko@sntech.de> <528C86C2.1070206@nvidia.com>
In-Reply-To: <528C86C2.1070206@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201311232225.48973.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

Am Mittwoch, 20. November 2013, 10:54:10 schrieb Laxman Dewangan:
> > I may be blind, but where get the early-irqs resumed in the error
> > path of dpm_suspend_noirq?
> > 
> > When a suspend_noirq callback returns an error, dpm_resume_noirq gets
> > called, which only calls resume_device_irqs while the
> > suspend_device_irqs call in dpm_suspend_noirq suspends all irqs. So it
> > does not seem that the early-irqs get resumed at all in this case.
> 
> I also faced same issue in our suspend failure path and posted fix
> sometime ago as
> https://lkml.org/lkml/2013/8/13/373
> 
> It is still under review.

>From the thread on lkml.org it looks like it got no reaction at all - maybe 
was just overlooked. So maybe it would be good to re-send it.

As it is not visible on lkml.org, did you also include stable@kernel.org, as 
the issue started in 2011?

> You can try this patch if it resolve the issue.

Your patch looks a lot more sophisticated than my current band-aid fix :-) by 
using the fact that irqs won't get resumed twice on their own.

So if you repost your patch you could add an

Acked-by: Heiko Stuebner <heiko@sntech.de>


Heiko
