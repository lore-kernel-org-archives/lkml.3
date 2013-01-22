Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3AVTuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:50:02 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53081 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3AVTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:50:01 -0500
Message-ID: <50FEED65.6050107@linaro.org>
Date: Tue, 22 Jan 2013 11:49:57 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] timekeeping: Add CONFIG_HAS_PERSISTENT_CLOCK option
References: <1358266189-8812-1-git-send-email-feng.tang@intel.com> <1358266189-8812-3-git-send-email-feng.tang@intel.com> <50F5B2FA.6030006@linaro.org> <20130122194433.GG30647@obsidianresearch.com>
In-Reply-To: <20130122194433.GG30647@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:44 AM, Jason Gunthorpe wrote:
> On Tue, Jan 15, 2013 at 11:50:18AM -0800, John Stultz wrote:
>> On 01/15/2013 08:09 AM, Feng Tang wrote:
>>> Make the persistent clock check a kernel config option, so that some
>>> platform can explicitely select it, also make CONFIG_RTC_HCTOSYS depends
>>> on its non-existence, which could prevent the persistent clock and RTC
>>> code from doing similar thing twice during system's init/suspend/resume
>>> phases.
>>>
>>> If the CONFIG_HAS_PERSISTENT_CLOCK=n, then no change happens for kernel
>>> which still does the persistent clock check in timekeeping_init().
>>>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Suggested-by: John Stultz <john.stultz@linaro.org>
>>> Signed-off-by: Feng Tang <feng.tang@intel.com>
>> Applied. I also added a dependency for Jason's CONFIG_RTC_SYSTOHC.
> Sort of an ugly config name, since I gather ARM should always set this
> to 'n'...
>
> CONFIG_USE_ONLY_PERSISTENT_CLOCK ?
(Sigh. I got this seemingly microseconds after I sent the pull request :)

So yea, fair point, there could be some confusion. But 
ONLY_PERSISTENT_CLOCK isn't quite right either,  more like 
CONFIG_HAS_PERSISTENT_CLOCK_ALWAYS or something.

Hrm. Let me think on it for a bit, and feel free to suggest further 
improvements.

thanks
-john
