Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423628Ab3FUSbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:31:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423383Ab3FUSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:31:50 -0400
Date: Fri, 21 Jun 2013 14:31:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 0/4] xen: maintain an accurate persistent clock in more
 cases
Message-ID: <20130621183132.GH15809@phenom.dumpdata.com>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
 <51C36016.7010806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C36016.7010806@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 01:03:34PM -0700, John Stultz wrote:
> On 06/20/2013 12:16 PM, David Vrabel wrote:
> >Xen guests use the Xen wallclock as their persistent clock.  This is a
> >software only clock in the hypervisor that is used by guests instead
> >of a real hardware RTC.
> >
> >The kernel has limited support for updating the persistent clock or
> >RTC when NTP is synced.  This has the following limitations:
> >
> >* The persistent clock is not updated on step changes.  This leaves a
> >   window where it will be incorrect (while NTP resyncs).
> >
> >* Xen guests use the Xen wallclock as their persistent clock.  dom0
> >   maintains this clock so it is persistent for domUs but not dom0
> >   itself.
> >
> >These limitations mean that guests started before NTP is synchronized
> >will start with an incorrect wallclock time and the hardware RTC will
> >not be updated (as on bare metal).
> >
> >These series fixes the above limitations and depends on "x86: increase
> >precision of x86_platform.get/set_wallclock()" which was previously
> >posted.
> >
> >Changes since v4:
> >
> >Dropped the change to disable non-boot CPUs during suspend on Xen as
> >migration downtime was too poor.  Instead, provide
> >hrtimers_late_resume() for use by Xen's resume code to replace the
> >call of clock_was_set().  Fix two unused variable warnings.
> 
> Ok, I've got these 4 in my pending stack. As long as Thomas doesn't
> object to the first two, and it doesn't run into any trouble in
> testing, I'll send them along for 3.12. (Acks from Xen maintainers
> would be nice for the last two as well).

Please consider them Acked-by.

Thanks!
> 
> Thanks for all the effort through all the revisions here!
> 
> thanks
> -john
> 
