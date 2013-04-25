Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3DYUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:03:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46221 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3DYUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:03:04 -0400
Message-ID: <51798BF4.5020602@linaro.org>
Date: Thu, 25 Apr 2013 13:03:00 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Alexander Holler <holler@ahsoftware.de>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org> <5178D719.2060405@ahsoftware.de> <5179562C.3000903@linaro.org> <20130425183301.GA31863@obsidianresearch.com>
In-Reply-To: <20130425183301.GA31863@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 11:33 AM, Jason Gunthorpe wrote:
> John mentioned they might be kept for embedded - eg size reduction.
> The issue with that idea is if you do not enable the class RTC
> subsystem then there is no way for a small embedded userspace to set
> the RTC. The /dev/rtc* device obviously goes away, but it also turns
> out that that CONFIG_GENERIC_CMOS_UPDATE only works when combined with
> a heavy weight userspace NTPD that runs the kernel PLL properly. The
> kernel NTP code is enormously conservative and it is actually quite
> hard to get it to write to the RTC. An RTC that cannot be set is
> useless, so these days I feel CONFIG_RTC is pragmatically mandatory -
> and my space constrained embedded systems do set it, for these
> reasons.

So I mentioned that the size-reduciton focused folks might not like the 
generic rtc core over the persistent_clock code, but I'm not convinced 
that's a reason to keep the persistent clock code (which isn't trivial 
size-wise itself). Instead either we can shrink the rtc core for those 
restricted uses or let them compile out the rtc core all together and 
let them manage time initialization completely in userland.

I only noted it, because it has come up prior as a complaint when 
switching to the RTC core was proposed.

thanks
-john

