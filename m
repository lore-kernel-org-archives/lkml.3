Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3HBOFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:05:45 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15075 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3HBOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:05:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Aug 2013 07:04:12 -0700
Message-ID: <51FBBCB1.9060906@nvidia.com>
Date: Fri, 2 Aug 2013 17:05:37 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.tegra,gmane.linux.usb.general
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/6] usb: phy: tegra: Program new PHY parameters
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-5-git-send-email-ttynkkynen@nvidia.com> <51FAD020.8090306@wwwdotorg.org>
In-Reply-To: <51FAD020.8090306@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 12:16 AM, Stephen Warren wrote:
> On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
>> The Tegra30 TRM recommends configuration of certain PHY parameters for
>> optimal quality. Program the following registers based on device tree
>> parameters:
>>
>> - UTMIP_XCVR_HSSLEW: HS slew rate control.
>> - UTMIP_HSSQUELCH_LEVEL: HS squelch detector level
>> - UTMIP_HSDISCON_LEVEL: HS disconnect detector level.
>>
>> These registers exist in Tegra20, but programming them hasn't been
>> necessary, so these parameters won't be set on Tegra20 to keep the
>> device trees backward compatible.
>>
>> Additionally, the UTMIP_XCVR_SETUP parameter can be set from fuses
>> instead of a software-programmed value, as the optimal value can
>> vary between invidual boards. The boolean property
>> nvidia,xcvr-setup-use-fuses can be used to enable this behaviour.
> 
>> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c

> Those two chunks end up clearing some fields in the register now even on
> earlier chips, whereas before their values were maintained when doing
> the read/modify/write. Yet, the commit description says the new fields
> aren't changed on Tegra20. Do the changes above need to be guarded by if
> (requires_extra_tuning_parameters)?

Oops, you are right. I overlooked that some of those fields have non-zero reset values.
