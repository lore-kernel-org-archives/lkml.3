Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3IRXC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:02:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55573 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3IRXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:02:25 -0400
Message-ID: <523A30FC.3060309@wwwdotorg.org>
Date: Wed, 18 Sep 2013 17:02:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org> <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
In-Reply-To: <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 02:41 PM, Olof Johansson wrote:
> On Wed, Sep 18, 2013 at 1:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
>> node that has a reg property must include a unit address in its name
>> with value matching the first entry in its reg property. Conversely, if
>> a node does not have a reg property, the node name must not include a
>> unit address.
>>
>> Implement a check for this. The code doesn't validate the format of the
>> unit address; ePAPR implies this may vary from binding to binding, so
>> I'm not sure that it's possible to validate the value itself.
...
> Anyway, I think it'd be better to produce warnings than errors for
> this. That way we could also merge it now while the trees are fixed
> up.

Yes, that makes sense.

> Also, maybe warn for @0x<foo>, which is another unpreferred syntax, it
> should just be @<foo> (with foo being in hex).

ePAPR doesn't seem to disallow that; it explicitly says that the
unit-address consists of the characters from table 2-1, which is the
same table of characters used for the node name itself. However, it does
state that the binding for a particular bus may impose additional
restrictions; should I implement such a check but limit it to the root
node or specific known bus types? That would require explicitly
whitelisting the check for a lot of bus types, given that each I2C/...
controller binding is a bus type...
