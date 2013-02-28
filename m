Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3B1Sv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:51:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49933 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096Ab3B1Sv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:51:26 -0500
Message-ID: <512FA72A.4060303@wwwdotorg.org>
Date: Thu, 28 Feb 2013 11:51:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: J Keerthy <j-keerthy@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361164283-3133-1-git-send-email-j-keerthy@ti.com> <512E5144.9020105@wwwdotorg.org> <512F1ADF.90906@nvidia.com>
In-Reply-To: <512F1ADF.90906@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 01:52 AM, Laxman Dewangan wrote:
> On Thursday 28 February 2013 12:02 AM, Stephen Warren wrote:
>> On 02/17/2013 10:11 PM, J Keerthy wrote:
>> +- interrupt-parent : The parent interrupt controller.
>> +
>> +Optional node:
>> +- Child nodes contain in the palmas. The palmas family is made of
>> several
>> +  variants that support a different number of features.
>> +  The child nodes will thus depend of the capability of the variant.
>> Are there DT bindings for those child nodes anywhere?
>>
>> Representing each internal component as a separate DT node feels a
>> little like designing the DT bindings to model the Linux-internal MFD
>> structure. DT bindings should be driven by the HW design and OS-agnostic.
>>
>>  From a DT perspective, is there any need at all to create a separate DT
>> node for each component? This would only be needed or useful if the
>> child IP blocks (and hence DT bindings for those blocks) could be
>> re-used in other top-level devices that aren't represented by this
>> top-level ti,palmas DT binding. Are the HW IP blocks here re-used
>> anywhere, or will they be?
> 
> 
> I dont think that child IP block can be used outside of the palma
> although other mfd device may have same IP.

That sounds like pretty much the definition of re-using the IP block...

> The child driver very much used the palma's API for register access and
> they can not be separated untill driver is write completely independent
> of palmas API. Currently, child driver include the palma header, uses
> palma mfd stcruture and plama's api for accessing registers.

The DT binding and compatible values should not be influenced by
OS-specific driver implementation details. DT bindings are supposed to
be (as near as possible) a pure HW description, which (many different)
OSs parse, and map to their internal driver structure as appropriate.

The above is of course just a comment on how DT is supposed to work; I'm
not saying anything here re: what's the most appropriate DT structure
for this device.

>>> +    palmas_pmic {
>> Just "pmic" seems simpler, although I dare say the node name isn't
>> really used for anything.
> 
> Stephen,
> Just curios, why do we require the palma_pmic node at all, We can start
> with regulator node directly. Is it not too much nested here?

That was the question I was asking in my original email. But I also
commented on the patch as written, in case the answer to my question was
that the child DT nodes made sense.
