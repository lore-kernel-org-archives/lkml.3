Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab3CMTRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:17:31 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47850 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3CMTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:17:30 -0400
Message-ID: <5140D0C5.1090000@linaro.org>
Date: Wed, 13 Mar 2013 12:17:25 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v4 0/4] Add support for S3 non-stop TSC support.
References: <1363060608-22657-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1363060608-22657-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 08:56 PM, Feng Tang wrote:
> Hi All,
>
> On some new Intel Atom processors (Penwell and Cloverview), there is
> a feature that the TSC won't stop in S3, say the TSC value won't be
> reset to 0 after resume. This feature makes TSC a more reliable
> clocksource and could benefit the timekeeping code during system
> suspend/resume cycles.
>
> The enabling efforts include adding new flags for this feature,
> modifying clocksource.h and timekeeping.c to support and utilizing
> it.
>
> The major change to timekeeping is the way to count suspended time,
> current way is trying to use the persistent clock first, and then
> try the rtc if persistent clock can't do it. This patch will change
> the trying order to:
> 	suspend-nonstop clocksource -> persistent clock -> rtc
>
> Please help to review them, thanks a lot!
>

Thanks!

I've gone ahead and queued these, with my minor modifications, for 3.10 
(pending further testing).

thanks
-john



