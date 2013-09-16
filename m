Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3IPWs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:48:28 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50959 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3IPWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:48:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1379371567.3721.46.camel@pasglop>
References: <1379300274.4098.77.camel@pasglop>
	<52372F2A.2050003@wwwdotorg.org>
	<1379371567.3721.46.camel@pasglop>
Date: Mon, 16 Sep 2013 15:48:22 -0700
Message-ID: <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
Subject: Re: "memory" binding issues
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 3:46 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2013-09-16 at 10:17 -0600, Stephen Warren wrote:
>> On 09/15/2013 08:57 PM, Benjamin Herrenschmidt wrote:
>> > [resent to the right list this time around]
>> >
>> > Hi folks !
>> >
>> > So I don't have the bandwidth to follow closely what's going on, but I
>> > just today noticed the crackpot that went into 3.11 as part of commit:
>> >
>> > 9d8eab7af79cb4ce2de5de39f82c455b1f796963
>> > drivers: of: add initialization code for dma reserved memory
>> >
>> > Fist of all, do NOT add (or change) a binding as part of a patch
>> > implementing code, it's gross.
>>
>> Personally, I would argue the opposite; it's much easier to see what's
>> going on when it's all together in one patch.
>
> One patch series eventually, but not the same patch.
>
>> Ensuring ABI stability can
>> only be achieved through code review, i.e. splitting into separate
>> DT/code patches won't achieve that, so that argument doesn't affect this.
>>
>> ...
>> > Additionally, it has the following issues:
>> >
>> >  - It describes the "memory" node as /memory, which is WRONG
>> >
>> > It should be "/memory@unit-address, this is important because the Linux
>> > kernel of_find_device_by_path() isn't smart enough to do partial
>> > searches (unlike the real OFW one) and thus to ignore the unit address
>> > for search purposes, and you *need* the unit address if you have
>> > multiple memory nodes (which you typically do on NUMA machines).
>>
>> Perhaps /memory should have had a unit-address, but it never has had on
>> ARM; see arch/arm/boot/dts/skeleton.dtsi which says:
>
> Well, this is a mistake ARM folks might have done from day one but it
> should still be fixed :-)
>
> A node that has a "reg" property should have the corresponding unit
> address.

No, absolutely _NOT_ a requirement. Unit address is only required if
needed to disambiguate two properties with the same name.

If there are no ambiguities, then leaving off the unit address is much
preferred.


-Olof
