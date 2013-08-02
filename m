Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3HBOPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:15:44 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15144 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3HBOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:15:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Aug 2013 07:14:12 -0700
Message-ID: <51FBBF0B.5020908@nvidia.com>
Date: Fri, 2 Aug 2013 17:15:39 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/6] usb: phy: tegra: Fix wrong PHY parameters
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-3-git-send-email-ttynkkynen@nvidia.com> <51FACE74.3070909@wwwdotorg.org>
In-Reply-To: <51FACE74.3070909@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 12:09 AM, Stephen Warren wrote:
> On 07/31/2013 11:41 AM, Tuomas Tynkkynen wrote:
>> Some of the PHY parameters are not set according to the TRMs:
>>
>> - UTMIP_FS_PREABMLE_J should be set, not cleared
>> - UTMIP_XCVR_LSBIAS_SEL should be cleared, not set
>> - UTMIP_PD_CHRG should be set in host mode and cleared in device mode
>> - UTMIP_XCVR_SETUP is a two-part field; the upper bits were not set
> 
>> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
> 
>>  #define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
>> +#define   UTMIP_XCVR_SETUP_MSB(x)		((((x) & 0x7f) >> 4) << 22)
> 
> You may as well s/0x7f/0x70/ since the shift clears the 4 LSBs. I'm
> pretty sure I mentioned this in downstream review. Perhaps check my
> review comments to see if anything else was missed?
> 

Well in my opinion that increases the risk of typoing the mask.
I'll fix along with the other things.
