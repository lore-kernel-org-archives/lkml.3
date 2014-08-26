Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbaHZMBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:01:36 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55696 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaHZMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:01:34 -0400
Message-ID: <53FC76E8.5050009@ahsoftware.de>
Date: Tue, 26 Aug 2014 14:00:40 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826102503.GC31124@ulmo> <53FC6513.5040800@ahsoftware.de> <20140826110827.GA31350@ulmo> <53FC6E4A.6030407@ahsoftware.de> <20140826114718.GB641@ulmo>
In-Reply-To: <20140826114718.GB641@ulmo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 13:47, schrieb Thierry Reding:
> On Tue, Aug 26, 2014 at 01:23:54PM +0200, Alexander Holler wrote:
>> Am 26.08.2014 13:08, schrieb Thierry Reding:
>>> On Tue, Aug 26, 2014 at 12:44:35PM +0200, Alexander Holler wrote:
>>>> Am 26.08.2014 12:25, schrieb Thierry Reding:
>>>>> On Tue, Aug 26, 2014 at 11:42:04AM +0200, Alexander Holler wrote:
>>>>
>>>>>> You need either the type information in the DTB (that's why I've add those
>>>>>> "dependencies" to identify phandles), or you need to know every binding (at
>>>>>> "dependency-resolve-time" to identify phandles. The latter is impracticable
>>>>>> to implement in a generic way (for use with every possible binding).
>>>>>
>>>>> Like I already mentioned, this could be done in drivers who contain that
>>>>> information already anyway. Or parts of it could be done in subsystem-
>>>>> specific callbacks where a generic binding is available.
>>>>
>>>> That would end up with almost the same ugly driver-based workarounds as now.
>>>> It's much better if a driver author only has to define it's prerequisits (in
>>>> form of dependencies in the dts) and could be sure the driver will only be
>>>> probed if those are met, than to do that stuff based on a subsystem or even
>>>> driver level.
>>>>
>>>> If you add dependency-information to drivers, you have two problems:
>>>
>>> We already have all that dependency information in drivers anyway. Each
>>> driver requests the resources at .probe() time. What I proposed (it was
>>> really Arnd who proposed it first) is to move that information out of
>>> code and into some sort of table that could be used by the driver core
>>> to figure out dependencies.
>>>
>>>> - How do you get these information from the driver (remember, currently
>>>> there is only one initial call, a initcall which might do almost anything)
>>>
>>> While I don't think it's necessary, that's something that could be
>>> changed. I mean, we have access to the full source code of this
>>> operating system, so we can change every aspect of it. If we can't find
>>> a way to make this work with the current initcall sequence it's always
>>> an option to extend that sequence so that it meets our needs.
>>>
>>>> - These information might become outdated and you would have to change all
>>>> drivers. E.g. if the name of a dependency (driver) changes it wouldn't be
>>>> done with changing the dts (maybe plural), but you would have to change the
>>>> source of all dependant drivers too.
>>>
>>> No. Drivers implement a DT binding. That binding defines what power
>>> supplies, clocks, pinmux, ... the device needs. Those constitute the
>>> dependencies. We most certainly don't want to depend on driver names
>>> since there can be a multitude of different drivers that provide a given
>>> dependency.
>>>
>>> What drivers should provide (and what they already provide today) is the
>>> name of the property and the index of the cell that they expect to find
>>> a phandle in as well as the type of the phandle. That's all that's
>>> necessary, really. Everything else can be derived from that phandle and
>>> the type.
>>
>> Drivers don't provide that information (dependencies) in any usable way. And
>> as you said yourself, it's already contained in phandles. So what we are
>> discussing here about? The proposal to use phandles for that is already on
>> the table since several month. ;)
>>
>> Sorry, but I don't understand what you want to propose.
>
> In many cases we simply don't know where phandles are stored since we
> don't have the type information in DT. But drivers already know the type
> of a specific phandle and where to get it from, so the proposal is to
> make that knowledge more generally useful so that it can be used for
> dependency resolution.

How?

Anyway, I'm leaving this discussion. I've already made a proposal which 
solved most mentioned problems (imho) and even offered usable patches 
(ok, they suffer under the "not invented here" syndrom, but ...). ;)

But please continue this discussion, I will try to not disturb it anymore.

Regards,

Alexander Holler

