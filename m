Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbbALJV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:21:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52411 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbALJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:21:56 -0500
Message-ID: <54B3922F.3010501@ti.com>
Date: Mon, 12 Jan 2015 11:21:51 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] phy: ti-pipe3: Disable clocks on system suspend
References: <1418990720-3638-1-git-send-email-rogerq@ti.com> <1418990720-3638-2-git-send-email-rogerq@ti.com> <54AFDE4A.2000205@ti.com>
In-Reply-To: <54AFDE4A.2000205@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kishon,

On 09/01/15 15:57, Kishon Vijay Abraham I wrote:
> Hi Roger,
> 
> On Friday 19 December 2014 05:35 PM, Roger Quadros wrote:
>> On system suspend, the runtime_suspend() driver hook doesn't get
>> called and so the clocks are not disabled in the driver.
>> This causes the L3INIT_960M_GFCLK and L3INIT_480M_GFCLK to remain
>> active on the DRA7 platform while in system suspend.
>>
>> Add suspend/resume hooks to the driver.
>> In case of pcie-phy, the runtime_suspend hook gets called after
> 
> This contradicts with the first line of your commit message. Is pcie-phy driver
> is an exception?

Yes in the pcie-phy case it behaves differently. I'll rewrite the message.

cheers,
-roger

> 
> Thanks
> Kishon
> 
>> the suspend hook so we introduce a flag phy->enabled to keep
>> track if our clocks are enabled or not to prevent multiple
>> enable/disables.
>>
>> Move enabling/disabling clock code into helper functions.
>>
>> Reported-by: Nishant Menon <nm@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>

