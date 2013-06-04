Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3FDWwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:52:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3FDWwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:52:17 -0400
Message-ID: <51AE6FA0.4030104@codeaurora.org>
Date: Tue, 04 Jun 2013 15:52:16 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] ARM: msm: Re-organize platsmp to make it extensible
References: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org> <1370305185-6450-3-git-send-email-rvaswani@codeaurora.org> <20130604093258.GS18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130604093258.GS18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2013 2:32 AM, Russell King - ARM Linux wrote:
> On Mon, Jun 03, 2013 at 05:19:44PM -0700, Rohit Vaswani wrote:
>> +	sc1_base_ptr = of_iomap(dn, 0);
>> +	if (sc1_base_ptr) {
>> +		writel_relaxed(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
>> +		writel_relaxed(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
>> +		writel_relaxed(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
>> +		mb();
>> +		iounmap(sc1_base_ptr);
> If you need to fiddle with power rails and resets for your secondary
> core, you don't need any of the pen_release stuff, and you really
> should get rid of it.  The pen_release stuff is only there for
> platforms where there's no proper way of controlling the secondary
> CPUs except by using a software method.

We currently don't have hotplug support as that also needs pen_release. 
We still need to do this.
We could change that behavior, but we would need more time for that. 
Please could we let this go through and cleanup the pen_release once we 
have hotplug working.

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

