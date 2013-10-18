Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3JRNf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:35:57 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:40655 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab3JRNfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:35:55 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2013 09:35:55 EDT
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131018025405.GA3722@codeaurora.org>
Date: Fri, 18 Oct 2013 16:28:29 +0300
Cc: Guenter Roeck <linux@roeck-us.net>,
        David Daney <ddaney@caviumnetworks.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <33103C16-6472-4AAE-ADB8-50807CC96C85@antoniou-consulting.com>
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org> <525F2397.40203@caviumnetworks.com> <20131017002731.GA22830@codeaurora.org> <525F6D83.1050808@roeck-us.net> <20131017235132.GA6241@codeaurora.org> <52608457.5040609@roeck-us.net> <20131018025405.GA3722@codeaurora.org>
To: Michael Bohan <mbohan@codeaurora.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Oct 18, 2013, at 5:54 AM, Michael Bohan wrote:

> On Thu, Oct 17, 2013 at 05:44:07PM -0700, Guenter Roeck wrote:
>> On 10/17/2013 04:51 PM, Michael Bohan wrote:
>>> On Wed, Oct 16, 2013 at 09:54:27PM -0700, Guenter Roeck wrote:
>>>> Still, what prevents you from unflattening it and just using the
>>>> normal device tree functions as David suggested ?
>>> 
>>> I'm assuming you're suggesting to use of_fdt_unflatten_tree()?
>> 
>> Yes, that was the idea.
>> 
>>> That's an interesting thought. I was planning to scan the fdt
>>> only once and populate my own structures, but I suppose I could
>>> use the of_* APIs equivalently.
>>> 
>>> It seems there are some problems though.  of_fdt_unflatten_tree()
>>> does not return errors, and so for the purposes of my driver it
>>> would not be sufficient to detect an invalid firmware image.
>>> 
>> It does so, at least partially. If there is an error, it won't set
>> the nodes pointer. Granted, that is not perfect, but it is at least
>> a start. Ultimately, I considered it 'good enough' for my purpose
>> (for devicetree overlays - see [1] below), as any missing mandatory
>> properties or nodes are detected later when trying to actually read
>> the properties. In my case, I also have a couple of validation
>> properties to ensure that the overlay is acceptable (specifically
>> I use 'compatible' and 'assembly-ids', but that is really a detail).
> 
> That's certainly better than nothing, but I think it would be
> useful to make a distinction between a malformed fdt and a fdt
> that's simply missing the right information. Without error
> codes, I think we lose this aspect.
> 
>>> Would people entertain changing this API
>>> (and implicitly __unflatten_device_tree) to return errors? I'm
>>> guessing the reason it's coded that way is because the normal
>>> usecase is 'system boot', at which time errors aren't that
>>> meaningful.
>>> 
>>> Also, there's no way to free the memory that was allocated from
>>> the unflatten process. May I add one?
>>> 
>> 
>> The patchset submitted by Pantelis Antoniou to add support for
>> devicetree overlays adds this and other related functionality.
>> See [1], specifically the patch titled "OF: Introduce utility
>> helper functions". Not sure where that is going, though.
>> It may need some cleanup to be accepted upstream.
>> Copying Pantelis for comments.
>> Guenter
>> 
>> [1] https://lkml.org/lkml/2013/1/4/276
> 
> Thanks. So it seems that Pantelis's __of_free_tree() is what I'm
> looking for.
> 

I guess it's time for another try to getting it in?

DT maintainers, which one of you will want to review?

> Mike
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

Regards

-- Pantelis

