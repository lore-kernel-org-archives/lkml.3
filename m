Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab3FEVgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:36:51 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:49523 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933051Ab3FEVgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:48 -0400
Message-ID: <51AFAF6D.7050204@itdev.co.uk>
Date: Wed, 05 Jun 2013 22:36:45 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net>
In-Reply-To: <20130605210715.GA16013@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>> debugfs is a debug filesystem. This interface is useful for purposes which
>> are not debug.
> 
> What other purposes does it serve? I'd expect you need it during new
> board bringup.

Yes, during board bringup it's extremely useful. We have implemented
numerous open and closed source utilities that can use this interface.

Run-time examples would be adjusting noise suppression or touch suppression
parameters based on something going on in the app layer (eg having
different parameters during unlock screen), or tuning report rates based on
application requirements, ot to inspect debug data if the touch sensor is
faulty. You might say, well we should implement an kernel driver interface
for these requirements, but they will vary hugely between different
products. We are trying to keep the driver as generic as possible and push
product-specific complexity to user space. Hence exposing the register map
and implementing user-space libraries to deal with this kind of customisation.

>> I have to be pragmatic: I don't see debugfs enabled on most
>> shipping Android devices, and however much I tell them to enable debugfs
>> doesn't seem to hold much weight.
> 
> You do not need to have debugfs enabled on shipping kernels, just the
> ones you use for integration work.

I disagree. See above.

>> It's partly path dependence - it was implemented like this because regmap
>> wasn't in mainline at the point when I wrote it. Having a dependency on
>> regmap would now be a API break complicating support of customers using
>> older kernels than mainline. I would also have to update a bunch of
>> software and documentation and people to know about the two different APIs.
>> The existing implementation already appears in shipping devices, so it is
>> well tested.
> 
> This was never a good argument for introducing an interface into the
> kernel.

Yes, I know. Just pointing out that making changes to this does result in a
significant cost.

>> I can look into porting on top of regmap. But it seems a pity to pepper
>> regmap with atmel_mxt_ts quirks just to save on three small functions in
>> the driver.
> 
> This is not about saving 3 functions but rather the fact that individual
> register access is desired by many parties and instead of each driver
> implementing it's own solution (via a char device, sysfs, debugfs, etc)
> we should try to standardize on common userspace interface.

I agree that a common interface is desirable. If regmap met the
requirements I would certainly use it instead.
