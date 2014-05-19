Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaESMgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:36:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35226 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaESMgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:36:10 -0400
Message-ID: <5379FAA5.10404@ahsoftware.de>
Date: Mon, 19 May 2014 14:35:49 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property
 'dependencies' which contains a list of referenced phandles
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <1399913280-6915-2-git-send-email-holler@ahsoftware.de> <53775334.3030704@gmail.com>
In-Reply-To: <53775334.3030704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2014 14:16, schrieb Tomasz Figa:

>> References to phandles of parent or child nodes will not be added to this
>> property, because this information is already contained in the blob (in the
>> form of the tree itself).
>
> I wonder if we shouldn't be including them too for consistency related
> reasons, so we have all the necessary information in one place.
> References to child nodes are great recipes for cycles, though...
>
> No strong opinion, though, just an idea.

As said, they are already in the tree itself. And they are already 
included in the graph (these are the black edges), so they just don't 
appear in the property dependencies.

>
>>
>> No dependencies to disabled nodes will be added.
>>
>
> Same here. IMHO it might be wise to let the parsing entity (e.g. kernel)
> decide whether to ignore a dependency to disabled node or not.
>
> Otherwise, I like the simplicity of compile-time dependency list
> creation. Quite a nice work.

Thanks.

What's still questionable about the patches for dtc is if dependencies 
to devices and not just drivers should be included in the new property 
dependencies too. My current assumption is that all devices belonging to 
one and the same driver don't have dependencies between each other. In 
other words the order in which devices will be attached to one and the 
same driver isn't important. If that assumption is correct it would be 
possible to just attach all devices belonging to a driver after the 
driver was loaded (also I haven't that done in my patches).

And thinking about that again, I think I was wrong and doing so have 
been some kind of evil premature optimization I did in order to spare a 
few dependencies/edges. But changing this can done by removing a few 
lines in the code for dtc (patch 1).

Regards,

Alexander Holler

