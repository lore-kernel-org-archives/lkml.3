Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab3IZXNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:13:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47715 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3IZXND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:13:03 -0400
Message-ID: <5244BF7A.4000100@wwwdotorg.org>
Date: Thu, 26 Sep 2013 17:12:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence
 mismatch
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org> <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org>
In-Reply-To: <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:21 PM, Kumar Gala wrote:
> 
> On Sep 19, 2013, at 12:54 PM, Stephen Warren wrote:
> 
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
>> node that has a reg property must include a unit address in its name
>> with value matching the first entry in its reg property. Conversely, if
>> a node does not have a reg property, the node name must not include a
>> unit address.
>>
>> Implement a check for this. The code doesn't validate the format of the
>> unit address; ePAPR implies this may vary from (containing bus) binding
>> to binding, so doing so would be much more complex.

> What about the case of no reg but a ranges?
> 
> This pattern shows up on a lot (if not all) the PPC dts:
> 
> arch/powerpc/boot/dts/mpc8544ds.dts:
> 
>         board_soc: soc: soc8544@e0000000 {
>                 ranges = <0x0 0x0 0xe0000000 0x100000>;

Well, ePAPR seems pretty specific that unit address and reg are related,
but says nothing about ranges in the section on node naming, nor about
node naming in the section about ranges.

I'd claim that the existing PPC trees are nonconforming, and should be
fixed too:-)
