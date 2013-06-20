Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966010Ab3FTUDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:03:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57536 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965968Ab3FTUDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:03:37 -0400
Message-ID: <51C36016.7010806@linaro.org>
Date: Thu, 20 Jun 2013 13:03:34 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 0/4] xen: maintain an accurate persistent clock in more
 cases
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 12:16 PM, David Vrabel wrote:
> Xen guests use the Xen wallclock as their persistent clock.  This is a
> software only clock in the hypervisor that is used by guests instead
> of a real hardware RTC.
>
> The kernel has limited support for updating the persistent clock or
> RTC when NTP is synced.  This has the following limitations:
>
> * The persistent clock is not updated on step changes.  This leaves a
>    window where it will be incorrect (while NTP resyncs).
>
> * Xen guests use the Xen wallclock as their persistent clock.  dom0
>    maintains this clock so it is persistent for domUs but not dom0
>    itself.
>
> These limitations mean that guests started before NTP is synchronized
> will start with an incorrect wallclock time and the hardware RTC will
> not be updated (as on bare metal).
>
> These series fixes the above limitations and depends on "x86: increase
> precision of x86_platform.get/set_wallclock()" which was previously
> posted.
>
> Changes since v4:
>
> Dropped the change to disable non-boot CPUs during suspend on Xen as
> migration downtime was too poor.  Instead, provide
> hrtimers_late_resume() for use by Xen's resume code to replace the
> call of clock_was_set().  Fix two unused variable warnings.

Ok, I've got these 4 in my pending stack. As long as Thomas doesn't 
object to the first two, and it doesn't run into any trouble in testing, 
I'll send them along for 3.12. (Acks from Xen maintainers would be nice 
for the last two as well).

Thanks for all the effort through all the revisions here!

thanks
-john

