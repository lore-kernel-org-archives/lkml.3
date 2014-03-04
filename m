Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaCDJe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:34:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44967 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaCDJeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:34:24 -0500
Message-ID: <53159E03.6010203@ti.com>
Date: Tue, 4 Mar 2014 11:33:55 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 03/12] phy: ti-pipe3: cleanup clock handling
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-4-git-send-email-rogerq@ti.com> <53159D0D.2040009@ti.com>
In-Reply-To: <53159D0D.2040009@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 11:29 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 03 March 2014 08:37 PM, Roger Quadros wrote:
>> As this driver is no longer USB specific, use generic clock names.
>> - Fix PLL_SD_SHIFT from 9 to 10
>> - As optclk and wkupclk may not be always required, don't bail out
>> if they aren't available.
> 
> I think here too we face the same problem as for PHY. What if a particular platform needs a clock but is not available. I don't want this to be blocking though.

Since we know for sure what clocks the different TI PHYs need, we could do the checks based on compatible id and always fail on clock error.

cheers,
-roger
