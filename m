Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaESR11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:27:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39807 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaESR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:27:25 -0400
Message-ID: <537A3EC4.9060801@ahsoftware.de>
Date: Mon, 19 May 2014 19:26:28 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Loeliger <loeliger@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Jon Loeliger <jdl@jdl.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property
 'dependencies' which contains a list of referenced phandles
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-2-git-send-email-holler@ahsoftware.de>	<53775334.3030704@gmail.com>	<5379FAA5.10404@ahsoftware.de> <CAJgR-BhRtc1XGqk-TVOrf2y_pYS+nratkPrf+OenP4SFcyK3ng@mail.gmail.com>
In-Reply-To: <CAJgR-BhRtc1XGqk-TVOrf2y_pYS+nratkPrf+OenP4SFcyK3ng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.05.2014 17:49, schrieb Jon Loeliger:
> [ Crap.  Sorry about the duplicate post.  Stupid HTML; didn't hit the
> lists. -- jdl ]
>
>
>> What's still questionable about the patches for dtc is if dependencies to
>> devices and not just drivers should be included in the new property
>> dependencies too.
>
> I don't think the DTC should have any semantic knowledge of why these
> dependency arcs are being added to the graph.  Sure, it could be that
> different types of arcs are added, and that the total dependency graph
> travels multiple such arc types to obtains some valid topological sort,
> but the DTC itself should just not care.

I will remove those policies (which means including all dependencies). 
As said below, I already thought it was evil premature optimization (I 
did in order to make the graph a bit smaller and to save some bytes). 
(No date, it isn't a paid project so I will do it whenever I feel good 
to do so).

> After saying that, there are likely semantic checks that could be added to
> ensure some policy about those arcs was followed.  Separate the
> implementation from the policy.  There is already plenty of discussion
> down that line within the DTC ongoing.

Hmm, discussion about what? Those dependencies or about semantic checks?

Btw., if someone has a problem with the necessary time to do the 
topological sort at boot time (needs a few ms on a single core omap with 
600 MHz), there could be an additional option to add a new property 
which includes the whole (already topological sorted) list. That 
wouldn't be much effort. But currently I don't think any DT enabled 
device is in need of having to avoid doing the topological sort itself.

Regards,

Alexander Holler

>
> HTH,
> jdl
>
>
> On Mon, May 19, 2014 at 7:35 AM, Alexander Holler <holler@ahsoftware.de>wrote:
>
>> Am 17.05.2014 14:16, schrieb Tomasz Figa:
>>
>>
>>   References to phandles of parent or child nodes will not be added to this
>>>> property, because this information is already contained in the blob (in
>>>> the
>>>> form of the tree itself).
>>>>
>>>
>>> I wonder if we shouldn't be including them too for consistency related
>>> reasons, so we have all the necessary information in one place.
>>> References to child nodes are great recipes for cycles, though...
>>>
>>> No strong opinion, though, just an idea.
>>>
>>
>> As said, they are already in the tree itself. And they are already
>> included in the graph (these are the black edges), so they just don't
>> appear in the property dependencies.
>>
>>
>>
>>>
>>>> No dependencies to disabled nodes will be added.
>>>>
>>>>
>>> Same here. IMHO it might be wise to let the parsing entity (e.g. kernel)
>>> decide whether to ignore a dependency to disabled node or not.
>>>
>>> Otherwise, I like the simplicity of compile-time dependency list
>>> creation. Quite a nice work.
>>>
>>
>> Thanks.
>>
>> What's still questionable about the patches for dtc is if dependencies to
>> devices and not just drivers should be included in the new property
>> dependencies too. My current assumption is that all devices belonging to
>> one and the same driver don't have dependencies between each other. In
>> other words the order in which devices will be attached to one and the same
>> driver isn't important. If that assumption is correct it would be possible
>> to just attach all devices belonging to a driver after the driver was
>> loaded (also I haven't that done in my patches).
>>
>> And thinking about that again, I think I was wrong and doing so have been
>> some kind of evil premature optimization I did in order to spare a few
>> dependencies/edges. But changing this can done by removing a few lines in
>> the code for dtc (patch 1).
>>
>> Regards,
>>
>> Alexander Holler
>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>

