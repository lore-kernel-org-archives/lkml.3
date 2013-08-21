Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3HUXPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:15:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58612 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3HUXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:15:50 -0400
Message-ID: <52154A22.4090809@wwwdotorg.org>
Date: Wed, 21 Aug 2013 17:15:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: hongbo.zhang@freescale.com, vinod.koul@intel.com, djbw@fb.com,
        leoli@freescale.com, linuxppc-dev@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>  <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>  <521541EE.4010303@wwwdotorg.org> <1377125827.5029.50.camel@snotra.buserror.net>
In-Reply-To: <1377125827.5029.50.camel@snotra.buserror.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 04:57 PM, Scott Wood wrote:
> On Wed, 2013-08-21 at 16:40 -0600, Stephen Warren wrote:
>> On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:

>>> +- ranges            : describes the mapping between the address space of the
>>> +                      DMA channels and the address space of the DMA controller
>>
>> Oh, so looking at the example, this is simply about being able to write
>> the reg value in the child nodes more easily without having to write out
>> the full based address of the controller in each child node.
>>
>> I don't think the binding document should require this;
> 
> It doesn't.  It just requires that there be a mapping; it doesn't have
> to be any particular mapping.
> 
>> all the binding document should care about is that the child nodes have a valid reg
>> value. Whether that reg value is <0x100100 0x80> without a ranges in the
>> top-level DMA
> 
> Without a ranges property there is no translation and the registers
> would not be memory mappable.  Linux may treat the absence of ranges as
> an identity mapping for compatibility with some broken OF trees, but
> it's not standard.

I would argue that missing ranges meaning 1:1 translation is now a
standard, given that it must be true to support some DTs, it therefore
can now be assumed?

>> nor or whether that reg value is <0x0 0x80> with a ranges
>> value in the top-level DMA node isn't something that the binding should
>> specify. Either way will work equally without affecting a driver for the
>> DMA controller; the parsing of reg with/without a ranges property is
>> more of a core part of DT than anything to do with this binding.
>>
>>> +- DMA channel nodes:
>>> +        - compatible        : must include "fsl,eloplus-dma-channel"
>>
>> Why do the channel nodes even need a compatible value? Presumably the
>> driver for the top-level DMA node will scan these dma-channel nodes to
>> extract the information it needs and will simply assume that all these
>> nodes are DMA channel nodes rather than something else? I suppose this
>> doesn't hurt, it just seems unnecessary unless you foresee other child
>> nodes types existing in the future and hence a need to differentiate
>> different types of nodes.
> 
> Other than "this is how the existing binding works and we're not going
> to break compatibility", it allows the OS more flexibility to choose
> whether to bind to controllers or directly to the channels.  Sometimes a
> channel will be labelled with a different compatible if it has a fixed
> purpose such as being connected to audio hardware (e.g. mpc8610_hpcd.dts
> where some channels are "fsl,ssi-dma-channel").

That sounds terribly like encoding policy into DT rather than it being a
HW description.
