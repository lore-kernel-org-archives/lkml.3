Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaJYSgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:36:44 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56120 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJYSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <20141023095339.GC6641@localhost>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
	<20141023095339.GC6641@localhost>
Date: Sat, 25 Oct 2014 09:28:36 +0200
Message-ID: <CABgxDoLcnzaAYuDMB3x=EdNrY=8mwjceVVCpfXUYBURVm44ZVQ@mail.gmail.com>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: devicetree <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

If that's still possible to do these changes, I am opened to suggestions.

2014-10-23 11:53 GMT+02:00 Johan Hovold <johan@kernel.org>:
> [ +CC: Guenter, Lee, linux-pm ]
>
> On Tue, Oct 14, 2014 at 06:31:09AM +0000, Romain Perier wrote:
>> Several drivers create their own devicetree property when they register
>> poweroff capabilities. This is for example the case for mfd, regulator
>> or power drivers which define "vendor,system-power-controller" property.
>> This patch adds support for a standard property "poweroff-source"
>
> Shouldn't this property really be called "power-off-source" or even
> "power-off-controller"?
>
> The power-off handler call-chain infrastructure is about to be merged
> and will be using power[-_ ]off (i.e. not "poweroff") consistently (at
> least in its interface).

"poweroff" or "power-off", I don't care. If people prefer "power-off",
choose this name :)

>
> Furthermore, isn't "controller" as in "power-off-controller" more
> appropriate than "source" in this case? We have wake-up sources, which
> might appear analogous, but that really isn't the same thing.

As I said, the idea with "power-off-source" (or "poweroff-source",
that's not the point here) is to mark the device as able to poweroff
the system, like "wakeup-source" which marks the device as able to
wakeup the system.
This is why I chose this name, because it is quite similar to wakeup
property except that it is for handling power, so it did make sense to
me.

The question is: what is the advantage of the suffix "controller"
compared to "source" ?

>
> I now this has already been merged to the regulator tree, but there's
> still still time to fix this.
>
>> which marks the device as able to shutdown the system.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> ---
>>  include/linux/of.h | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index 6545e7a..27b3ba1 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -866,4 +866,15 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
>>  /* CONFIG_OF_RESOLVE api */
>>  extern int of_resolve_phandles(struct device_node *tree);
>>
>> +/**
>> + * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
>> + * @np: Pointer to the given device_node
>> + *
>> + * return true if present false otherwise
>> + */
>> +static inline bool of_system_has_poweroff_source(const struct device_node *np)
>
> Why "system_has"? Shouldn't this be of_is_power_off_source (controller)?

Note that the current custom vendor properties contain "system-" as prefix ;)

we have several possibilities:
- of_system_has_power_off_source()
- of_has_power_off_source()

We should either to use "has" or "is" as prefix because that's a
predicate function.
I would prefer "has" since it refers to a property inside a node :
this node "has" the corresponding property, so "is" is not a good
candidate.

Have a nice day,
Romain
