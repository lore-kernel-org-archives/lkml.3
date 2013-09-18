Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3IRQ2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:28:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52409 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IRQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:28:47 -0400
Message-ID: <5239D4BC.3030600@wwwdotorg.org>
Date: Wed, 18 Sep 2013 10:28:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: "memory" binding issues
References: <1379300274.4098.77.camel@pasglop> <1379371567.3721.46.camel@pasglop> <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com> <1815499.tpfeUKmP6V@flatron> <20130917164307.GA31327@quad.lixom.net> <5238C4D1.6060500@gmail.com> <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
In-Reply-To: <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 03:15 PM, Olof Johansson wrote:
> On Tue, Sep 17, 2013 at 2:08 PM, Frank Rowand <frowand.list@gmail.com> wrote:
>> On 9/17/2013 9:43 AM, Olof Johansson wrote:
>>> On Tue, Sep 17, 2013 at 09:56:39AM +0200, Tomasz Figa wrote:
>>>> I'm afraid that I must disagree. For consistency I'd rather go with what
>>>> Ben said. Please see ePAPR chapter 2.2.1.1, which clearly defines how
>>>> nodes should be named.
>>>
>>> 2.2.1.1 is there to point out that unit address _has_ to reflect reg.
>>>
>>> 2.2.3 says that unit addresses can be omitted.
>>
>> 2.2.3 is talking about path names.
>>
>> 2.2.1.1 is talking about node names.
>>
>> 2.2.1.1 _does_ require the unit address in the node name, 2.2.3 does not
>> remove that requirement.
> 
> Sigh, that's horrible. OF clearly doesn't require it.
> 
> I guess people prefer to follow ePAPR even though it's broken? That
> means someone needs to cleanup the current dts files. Any takers?

FWIW, I investigated enhancing dtc to enforce this rule. Here are the
results:

********** TEST SUMMARY
*     Total testcases:	1446
*                PASS:	1252
*                FAIL:	58
*   Bad configuration:	136
* Strange test result:	0
**********

That's just in dtc itself, and not any of the *.dts in the kernel or
U-Boot source trees...

I'll see how much of patch it takes to fix up all the test-cases in dtc.
