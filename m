Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750813Ab3JQEyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 00:54:36 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55861 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3JQEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 00:54:34 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525F6D83.1050808@roeck-us.net>
Date: Wed, 16 Oct 2013 21:54:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>,
        David Daney <ddaney@caviumnetworks.com>
CC: David Gibson <david@gibson.dropbear.id.au>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org> <525F2397.40203@caviumnetworks.com> <20131017002731.GA22830@codeaurora.org>
In-Reply-To: <20131017002731.GA22830@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 05:27 PM, Michael Bohan wrote:
> On Wed, Oct 16, 2013 at 04:39:03PM -0700, David Daney wrote:
>> On 10/16/2013 04:27 PM, Michael Bohan wrote:
>>> Ever since the following commit, libfdt has been available for
>>> usage in the kernel:
>>>
>>>       commit ab25383983fb8d7786696f5371e75e79c3e9a405
>>>       Author: David Daney <david.daney@cavium.com>
>>>       Date:   Thu Jul 5 18:12:38 2012 +0200
>>>
>>>       of/lib: Allow scripts/dtc/libfdt to be used from kernel code
>>>
>>> Export these functions to modules so that they may be used
>> >from device drivers.
>>> ---
>>> +EXPORT_SYMBOL_GPL(fdt_next_tag);
>>
>> The code was all written by David Gibson, and is dual GPL/BSD
>> licensed.  So I am not sure you should be using the GPL flavor of
>> the export directive.
>
> Yeah, I wasn't quite sure about this myself. I can remove the GPL
> if it's incorrect.
>
>> But more than this.  I don't understand why a driver would be
>> parsing the FDT in the first place.  If there is a device tree, why
>> hasn't it been unflattened, and thus used via the normal device tree
>> functions.
>
> My motivation is actually to use the fdt format as a firmware.
> I have a requirement to express driver metadata that's loadable
> from the filesystem. This data is not reasonable to place in the
> system Device Tree, since it's application specific and does not
> actually describe hardware. The fact that the format chosen is
> 'flattened device tree' is merely just a coincidence.
>
Still, what prevents you from unflattening it and just using the
normal device tree functions as David suggested ?

Guenter

> When considering formats, dts / fdt is convenient since:
>
> -The dts syntax meets requirements by being human-readable.
> -There exists a device-tree compiler already
> -Linux knows how to deal with fdt, so the driver implementation
>   becomes more simple.
>
> Thanks,
> Mike
>

