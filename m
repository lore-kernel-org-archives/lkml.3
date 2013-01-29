Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3A2KIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:08:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59755 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3A2KIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:08:35 -0500
Message-ID: <51079F97.6080109@ti.com>
Date: Tue, 29 Jan 2013 12:08:23 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <tony@atomide.com>, <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
References: <1359372631-8180-11-git-send-email-rogerq@ti.com> <1359453032-20604-1-git-send-email-rogerq@ti.com> <20130129095758.GM8708@arwen.pp.htv.fi>
In-Reply-To: <20130129095758.GM8708@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 11:57 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jan 29, 2013 at 11:50:32AM +0200, Roger Quadros wrote:
>> For each port that is in PHY mode we obtain a PHY device using the USB PHY
>> library and put it out of suspend.
>>
>> It is up to platform code to associate the PHY to the controller's
>> port and it is upto the PHY driver to manage the PHY's resources.
>>
>> Also remove wired spacing around declarations we come across.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> ideally, this would be done generically by ehci-hcd.ko itself. Alan,
> would you have objections provided it doesn't break anyone else ?
> 
Agreed, and PHY suspend/resume should be done at port granularity.

But considering the erratas we have in OMAP EHCI, I would still prefer to
have control of the PHY in ehci-omap. We might even have to do some ULPI
transfers in certain scenarios to work around some of the erratas.

cheers,
-roger
