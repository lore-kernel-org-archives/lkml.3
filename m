Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3HSMR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:17:56 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:42866 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3HSMRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1308162117240.24059-100000@netrider.rowland.org>
References: <20130816224654.GV30073@sirena.org.uk>
	<Pine.LNX.4.44L0.1308162117240.24059-100000@netrider.rowland.org>
Date: Mon, 19 Aug 2013 20:17:53 +0800
Message-ID: <CACVXFVPFqHLQRpd0QBzoVapqHtKqrfGvWT0_nhXeFqjQVRsp5Q@mail.gmail.com>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 9:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 16 Aug 2013, Mark Brown wrote:
>
>> > Besides, you need to get the platform information to the driver in any
>> > case, no matter how you decide to solve the chicken-and-egg problem.
>> > It shouldn't be a factor in deciding which solution to use.
>>
>> It's not that this is hard, it's that I don't see how if you already
>> have some concept of the device in the kernel data structures (which you
>> must have in order to be able to provide platform data when it's needed)
>> anything is gained by not using that when dealing with bootstrapping
>> issues.
>
> I agree.  In fact, there's no choice but to use this device concept
> during startup.  Otherwise there's no way to get the platform data to
> the driver when it is needed, because there's no way to tell which
> device the data applies to.  The question is how elaborate the concept
> needs to be and how it gets used.
>
> Aong those lines, I would like to point out that the device concept
> embodied in the kernel's data structures can be pretty thin.  For
> example, it might be little more than a port number or bus address.

Maybe the principle behind drivers/usb/core/usb-acpi.c is helpful
for the problem, and DT may refer to ACPI to describe on-board
USB devices, and the way to retrieve platform data too.

>> Anyway, I think it's time to try to implement something rather than talk
>> about it.
>
> Hopefully this discussion has given you some ideas for alternative
> approachs, or at least helped to solidify your ideas.


Thanks,
-- 
Ming Lei
