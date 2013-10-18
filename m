Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JRCyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 22:54:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50810 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3JRCyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 22:54:11 -0400
Date: Thu, 17 Oct 2013 19:54:06 -0700
From: Michael Bohan <mbohan@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
Message-ID: <20131018025405.GA3722@codeaurora.org>
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
 <525F2397.40203@caviumnetworks.com>
 <20131017002731.GA22830@codeaurora.org>
 <525F6D83.1050808@roeck-us.net>
 <20131017235132.GA6241@codeaurora.org>
 <52608457.5040609@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52608457.5040609@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:44:07PM -0700, Guenter Roeck wrote:
> On 10/17/2013 04:51 PM, Michael Bohan wrote:
> >On Wed, Oct 16, 2013 at 09:54:27PM -0700, Guenter Roeck wrote:
> >>Still, what prevents you from unflattening it and just using the
> >>normal device tree functions as David suggested ?
> >
> >I'm assuming you're suggesting to use of_fdt_unflatten_tree()?
> 
> Yes, that was the idea.
> 
> >That's an interesting thought. I was planning to scan the fdt
> >only once and populate my own structures, but I suppose I could
> >use the of_* APIs equivalently.
> >
> >It seems there are some problems though.  of_fdt_unflatten_tree()
> >does not return errors, and so for the purposes of my driver it
> >would not be sufficient to detect an invalid firmware image.
> >
> It does so, at least partially. If there is an error, it won't set
> the nodes pointer. Granted, that is not perfect, but it is at least
> a start. Ultimately, I considered it 'good enough' for my purpose
> (for devicetree overlays - see [1] below), as any missing mandatory
> properties or nodes are detected later when trying to actually read
> the properties. In my case, I also have a couple of validation
> properties to ensure that the overlay is acceptable (specifically
> I use 'compatible' and 'assembly-ids', but that is really a detail).

That's certainly better than nothing, but I think it would be
useful to make a distinction between a malformed fdt and a fdt
that's simply missing the right information. Without error
codes, I think we lose this aspect.

> >Would people entertain changing this API
> >(and implicitly __unflatten_device_tree) to return errors? I'm
> >guessing the reason it's coded that way is because the normal
> >usecase is 'system boot', at which time errors aren't that
> >meaningful.
> >
> >Also, there's no way to free the memory that was allocated from
> >the unflatten process. May I add one?
> >
> 
> The patchset submitted by Pantelis Antoniou to add support for
> devicetree overlays adds this and other related functionality.
> See [1], specifically the patch titled "OF: Introduce utility
> helper functions". Not sure where that is going, though.
> It may need some cleanup to be accepted upstream.
> Copying Pantelis for comments.
> Guenter
> 
> [1] https://lkml.org/lkml/2013/1/4/276

Thanks. So it seems that Pantelis's __of_free_tree() is what I'm
looking for.

Mike

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
