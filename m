Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3F0RhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:37:24 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55616 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3F0RhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:37:23 -0400
Message-ID: <51CC7850.2040602@linaro.org>
Date: Thu, 27 Jun 2013 10:37:20 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] time: indicate that the clock was set in the pvclock
 gtod notifier chain
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-4-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1372329348-20841-4-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 03:35 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> If the clock was set (stepped), set the action parameter to functions
> in the pvclock gtod notifier chain to non-zero.  This allows the
> callee to only do work if the clock was stepped.
>
> This will be used on Xen as the synchronization of the Xen wallclock
> to the control domain's (dom0) system time will be done with this
> notifier and updating on every timer tick is unnecessary and too
> expensive.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Looks pretty good. Minor note below.


>
> @@ -1239,9 +1240,10 @@ out_adjust:
>    * It also calls into the NTP code to handle leapsecond processing.
>    *
>    */
> -static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
> +static inline bool accumulate_nsecs_to_secs(struct timekeeper *tk)
Shouldn't this be unsigned instead of bool?


thanks
-john

