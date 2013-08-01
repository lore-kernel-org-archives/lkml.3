Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3HAVJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:09:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33677 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3HAVJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:09:11 -0400
Message-ID: <51FACE74.3070909@wwwdotorg.org>
Date: Thu, 01 Aug 2013 15:09:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH 2/6] usb: phy: tegra: Fix wrong PHY parameters
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-3-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292522-7855-3-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:41 AM, Tuomas Tynkkynen wrote:
> Some of the PHY parameters are not set according to the TRMs:
> 
> - UTMIP_FS_PREABMLE_J should be set, not cleared
> - UTMIP_XCVR_LSBIAS_SEL should be cleared, not set
> - UTMIP_PD_CHRG should be set in host mode and cleared in device mode
> - UTMIP_XCVR_SETUP is a two-part field; the upper bits were not set

> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c

>  #define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
> +#define   UTMIP_XCVR_SETUP_MSB(x)		((((x) & 0x7f) >> 4) << 22)

You may as well s/0x7f/0x70/ since the shift clears the 4 LSBs. I'm
pretty sure I mentioned this in downstream review. Perhaps check my
review comments to see if anything else was missed?
