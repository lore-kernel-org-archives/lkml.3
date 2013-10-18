Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3JRTci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:32:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59619 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3JRTcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:32:35 -0400
Date: Fri, 18 Oct 2013 12:32:29 -0700
From: Michael Bohan <mbohan@codeaurora.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Guenter Roeck <linux@roeck-us.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
Message-ID: <20131018193229.GA30141@codeaurora.org>
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
 <525F2397.40203@caviumnetworks.com>
 <20131017002731.GA22830@codeaurora.org>
 <525F6D83.1050808@roeck-us.net>
 <20131017235132.GA6241@codeaurora.org>
 <52608457.5040609@roeck-us.net>
 <20131018025405.GA3722@codeaurora.org>
 <33103C16-6472-4AAE-ADB8-50807CC96C85@antoniou-consulting.com>
 <52615A64.9040803@gmail.com>
 <52616228.80002@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52616228.80002@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 09:30:32AM -0700, David Daney wrote:
> On 10/18/2013 08:57 AM, Rob Herring wrote:
> [...]
> >
> >Unflattening is definitely the right
> >direction to go here.
> >
> 
> I wonder if that is really true.
> 
> The device tree in question is very short lived, and used to control
> the configuration of some hardware device when loading the driver.
> 
> The use of it is completely contained within a single driver (at
> least that is my understanding), it is not information that needs to
> be shared system wide.

That's correct.

> Given that it is a driver implementation issue, rather than making
> things work nicely system wide, I don't think it really matters what
> is done.
> 
> It may be that the overhead of unflattening the tree and then
> freeing it, is much greater than just extracting a few things from
> the FDT.

Yes, this was my original thought as well. On the other hand,
having libfdt in the kernel does add a little extra bloat, and so
it seems a tradeoff from one-time runtime overhead to footprint.

> That said, I don't really have a preference for what is done.  My
> original questions were targeted at understanding this particular
> use case.

My preference is probably straight libfdt calls, but if others
think that unpacking is a better solution, I'm able to go that
route as well. My only concern there is that we provide a means
to detect invalid dtb image (ex. handle error codes) and also
free the device_node allocations once the device is released.

Thanks,
Mike

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
