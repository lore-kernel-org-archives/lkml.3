Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3JQXvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:51:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42273 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3JQXvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:51:39 -0400
Date: Thu, 17 Oct 2013 16:51:32 -0700
From: Michael Bohan <mbohan@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, david.daney@cavium.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
Message-ID: <20131017235132.GA6241@codeaurora.org>
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
 <525F2397.40203@caviumnetworks.com>
 <20131017002731.GA22830@codeaurora.org>
 <525F6D83.1050808@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525F6D83.1050808@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:54:27PM -0700, Guenter Roeck wrote:
> On 10/16/2013 05:27 PM, Michael Bohan wrote:
> >My motivation is actually to use the fdt format as a firmware.
> >I have a requirement to express driver metadata that's loadable
> >from the filesystem. This data is not reasonable to place in the
> >system Device Tree, since it's application specific and does not
> >actually describe hardware. The fact that the format chosen is
> >'flattened device tree' is merely just a coincidence.
> >
> Still, what prevents you from unflattening it and just using the
> normal device tree functions as David suggested ?

I'm assuming you're suggesting to use of_fdt_unflatten_tree()?
That's an interesting thought. I was planning to scan the fdt
only once and populate my own structures, but I suppose I could
use the of_* APIs equivalently.

It seems there are some problems though.  of_fdt_unflatten_tree()
does not return errors, and so for the purposes of my driver it
would not be sufficient to detect an invalid firmware image. 

Would people entertain changing this API
(and implicitly __unflatten_device_tree) to return errors? I'm
guessing the reason it's coded that way is because the normal
usecase is 'system boot', at which time errors aren't that
meaningful.

Also, there's no way to free the memory that was allocated from
the unflatten process. May I add one?

Thanks,
Mike

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
