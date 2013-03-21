Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3CUSNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:13:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27775 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3CUSNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:13:18 -0400
X-IronPort-AV: E=Sophos;i="4.84,887,1355126400"; 
   d="scan'208";a="31622448"
Message-ID: <514B4DBD.4060403@codeaurora.org>
Date: Thu, 21 Mar 2013 11:13:17 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-2-git-send-email-sboyd@codeaurora.org> <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 11:09, Mark Rutland wrote:
> Hi Stephen,
>
> I've just been trying to test the dummy timer, and realised it's broken, as it
> registers a cpu notifier from a device_initcall (after SMP's been brought up),
> and doesn't ensure all active CPUs have been set up. Evidently no-one else has
> attempted to test it thus far, and I'm not able to throughly test it at the
> moment.

Would it be sufficient to register as a pre-smp initcall?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

