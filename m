Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab3HNQau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:30:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002Ab3HNQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:30:48 -0400
Message-ID: <520BB0B4.4090400@wwwdotorg.org>
Date: Wed, 14 Aug 2013 10:30:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Non-enumerable devices on USB and other enumerable buses
References: <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 10:14 AM, Alan Stern wrote:
> On Wed, 14 Aug 2013, Mark Brown wrote:
> 
>> On Wed, Aug 14, 2013 at 10:27:26AM -0400, Alan Stern wrote:
>>> On Wed, 14 Aug 2013, Mark Brown wrote:
>>
>>>> I'd expect that we're just looking at hooks around connection and
>>>> disconnection here here - if we're looking at much more it seems like we
>>>> must be doing something wrong.
>>
>>> Connection and disconnection of what?
>>
>> The device on the bus.
>>
>>> In the example mentioned earlier, the GPIOs to power an on-board USB
>>> hub would have to be initialized when the host controller was started.  
>>> You wouldn't want to wait for the on-board hub to be detected, because
>>> without those GPIOs set properly, it never would be discovered on the
>>> USB bus.  Right?
>>
>> Yes, so you'd want callbacks when the device actually appears and
>> disappears.
> 
> No, no -- this is exactly the point I was trying to make.  The on-board
> hub _won't_ appear on the USB bus until the GPIOs are set.  Therefore
> the callback to set the GPIOs needs to be at a different place, not
> when the device appears.

The device Mark was talking about is the controller end of the bus (EHCI
controller, or hub's downstream port) not the device end of the bus (any
USB device's upstream port).
