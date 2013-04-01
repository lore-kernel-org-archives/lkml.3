Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3DAUlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:41:35 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59897 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3DAUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:41:34 -0400
Message-ID: <5159F0FA.40306@linaro.org>
Date: Mon, 01 Apr 2013 13:41:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD48B6.9010202@intel.com> <20130330181451.GF28947@amd.pavel.ucw.cz> <5159C4AE.2050504@linaro.org> <20130401203136.GA2543@amd.pavel.ucw.cz>
In-Reply-To: <20130401203136.GA2543@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 01:31 PM, Pavel Machek wrote:
>
> Certainly for short sleeps. Is TSC actually precise enough to keep
> precise time for hours? I thought TSC sucked at precision.

Well, we can measure suspend using the ntp corrected frequency, so that 
should be ok, assuming the freq doesn't change during suspend.

But yes, the long term accuracy will depend on the actual hardware 
implementation, so we'll have to see what the hardware does.

Even so, other boards have similar non-stop clocksources in suspend that 
could be used in a similar fashion, so I think this is still the right 
appraoch.

thanks
-john
