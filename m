Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3L0SXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:23:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37104 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3L0SXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:23:12 -0500
Message-ID: <52BDC58E.2040101@codeaurora.org>
Date: Fri, 27 Dec 2013 10:23:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: balbi@ti.com, "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 01/15] usb: phy: msm: Move mach dependent code to platform
 data
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com> <1384267910-32066-2-git-send-email-iivanov@mm-sol.com> <20131227181009.GF7819@saruman.home>
In-Reply-To: <20131227181009.GF7819@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/13 10:10, Felipe Balbi wrote:
> Hi,
>
> On Tue, Nov 12, 2013 at 04:51:36PM +0200, Ivan T. Ivanov wrote:
>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>>
>> This patch fix compilation error when driver is compiled
>> in multi-platform builds.
>>
>> drivers/built-in.o: In function `msm_otg_link_clk_reset':
>> ./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
>> ./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'
>>
>> Use platform data supplied reset handlers and adjust error
>> messages reported when reset sequence fail.
>>
>> This is an intermediate step before adding support for reset
>> framework and newer targets.
>>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> Acked-by: David Brown <davidb@codeaurora.org>
>> Cc: Daniel Walker <dwalker@fifo99.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> this really looks like you should be using reset framework
> (drivers/reset/), then your phy driver would simply reset_assert() and
> reset_deassert().
>

Unfortunately the reset framework is a DT only framework and there are
still non-DT platforms within mach-msm. Arnd suggested we push the
non-DT reset code down into the mach directory in the meantime. We're in
the process of adding the reset framework to DT enabled MSM platforms,
hopefully those get merged in 3.14.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

