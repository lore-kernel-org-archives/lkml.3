Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3JSDlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 23:41:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56184 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3JSDlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 23:41:09 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5261FF4D.1080005@roeck-us.net>
Date: Fri, 18 Oct 2013 20:41:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>, Rob Herring <robherring2@gmail.com>
CC: David Daney <ddaney@caviumnetworks.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
References: <20131017002731.GA22830@codeaurora.org> <525F6D83.1050808@roeck-us.net> <20131017235132.GA6241@codeaurora.org> <52608457.5040609@roeck-us.net> <20131018025405.GA3722@codeaurora.org> <33103C16-6472-4AAE-ADB8-50807CC96C85@antoniou-consulting.com> <52615A64.9040803@gmail.com> <52616228.80002@caviumnetworks.com> <20131018193229.GA30141@codeaurora.org> <5261A609.1020605@gmail.com> <20131019014919.GB30244@codeaurora.org>
In-Reply-To: <20131019014919.GB30244@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 06:49 PM, Michael Bohan wrote:
> On Fri, Oct 18, 2013 at 04:20:09PM -0500, Rob Herring wrote:
>> On 10/18/2013 02:32 PM, Michael Bohan wrote:
>>> My preference is probably straight libfdt calls, but if others
>>> think that unpacking is a better solution, I'm able to go that
>>> route as well. My only concern there is that we provide a means
>>> to detect invalid dtb image (ex. handle error codes) and also
>>> free the device_node allocations once the device is released.
>>
>> I think we need to understand what you are putting in the DT first.
>
> That's understandable. Please see my response to Mark.
>
>> Given there are other desired uses like overlays which need to add the
>> necessary loading and unflattening support, a common solution is likely
>> more desirable.
>
> But by convention, would overlays allow for 'application
> specific' data, or are they expected to meet the more rigid
> requirements of a real Device Tree?
>

Not that I am the authority on it, but the idea is that devicetree overlays
will be merged with the existing devicetree, which implies that the same
requirements would apply.

However, you would not really use overlays. You would use the devicetree
infrastructure to create a logically separate instance of a devicetree
to dynamically configure your driver (which I think is an ingenious idea).
I don't think the same rules would or should apply there.

Guenter

