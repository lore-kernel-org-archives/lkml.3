Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3GJIIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:08:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32899 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3GJIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:08:07 -0400
Message-ID: <51DD1663.60006@ti.com>
Date: Wed, 10 Jul 2013 11:08:03 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: host: Use usb_hcd_platform_shutdown() wherever possible
References: <Pine.LNX.4.44L0.1307091015310.1077-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307091015310.1077-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 05:16 PM, Alan Stern wrote:
> On Tue, 9 Jul 2013, Roger Quadros wrote:
> 
>> Most HCD drivers are doing the same thing in their ".shutdown" callback
>> so it makes sense to use the generic usb_hcd_platform_shutdown()
>> handler there.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/usb/host/ehci-grlib.c     |   11 +----------
>>  drivers/usb/host/ehci-mxc.c       |   10 +---------
>>  drivers/usb/host/ehci-omap.c      |   10 +---------
>>  drivers/usb/host/ehci-ppc-of.c    |   11 +----------
>>  drivers/usb/host/ehci-s5p.c       |   10 +---------
>>  drivers/usb/host/ehci-tegra.c     |   10 +---------
>>  drivers/usb/host/ehci-xilinx-of.c |   17 +----------------
>>  drivers/usb/host/ohci-omap3.c     |   10 +---------
>>  8 files changed, 8 insertions(+), 81 deletions(-)
> 
> This all looks fine.  But unless my kernel tree is out of date, you 
> missed ohci-ppc-of.c.

You are right. I missed it and will send a revision.

I've also noticed some drivers doing non-standard stuff.
e.g.
- ehci-ps3.c and ohci-pst set .shutdown as well as .remove to to ps3_ehci_remove
- ehci-tilegx.c and ohci-tilegx call .remove in the .shutdown path
- ehci-mv.c checks for (!hcd->rh_registered) in the shudown & remove patch.
Is this necessary?

cheers,
-roger
