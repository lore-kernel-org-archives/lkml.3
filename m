Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3BVUnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:43:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61813 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab3BVUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:43:02 -0500
Message-ID: <5127D853.6030703@linaro.org>
Date: Fri, 22 Feb 2013 12:42:59 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: Re: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with
 ntp
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1360861375-24131-2-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
> Every 11 minutes ntp attempts to update the x86 rtc with the current
> system time.  Currently, the x86 code only updates the rtc if the system
> time is within +/-15 minutes of the current value of the rtc.  Other
> architectures do a full synchronization and there is no reason that x86
> should be software limited to a 30 minute window.
>
> This patch changes the behavior of the kernel to do a full synchronization
> (year, month, day, hour, minute, and second) of the rtc when ntp requests
> a synchronization between the system time and the rtc.
>
> I've used the RTC library functions in this patchset as they do all the
> required bounds checking.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: x86@kernel.org
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: linux-efi@vger.kernel.org


This looks reasonable to me.

Though I want to make sure we get this thoroughly tested by the various 
distros so we don't surprise anyone, since it has to potential to cause 
problems where folks are dualbooting windows (using a localtime RTC) and 
do not have their OS setup to trigger warp_clock to adjust for the 
localtime rtc (instead getting a time correction later via NTP).

I'll queue it and see about getting it merged to -tip & -next. Then 
we'll have to decide if 3.10 or 3.11 is the right time frame to land it.

thanks
-john


