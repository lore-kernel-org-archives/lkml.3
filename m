Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3HUXM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:12:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41314 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3HUXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:12:57 -0400
Message-ID: <52154976.2010204@wwwdotorg.org>
Date: Wed, 21 Aug 2013 17:12:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: hongbo.zhang@freescale.com, vinod.koul@intel.com, djbw@fb.com,
        leoli@freescale.com, linuxppc-dev@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] DMA: Freescale: revise device tree binding document
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>  <1375094944-3343-2-git-send-email-hongbo.zhang@freescale.com>  <5215402E.70007@wwwdotorg.org> <1377125156.5029.40.camel@snotra.buserror.net>
In-Reply-To: <1377125156.5029.40.camel@snotra.buserror.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 04:45 PM, Scott Wood wrote:
> On Wed, 2013-08-21 at 16:33 -0600, Stephen Warren wrote:
>> On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:
>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>
>>> This patch updates the discription of each type of DMA controller and its
>>> channels, it is preparation for adding another new DMA controller binding, it
>>> also fixes some defects of indent for text alignment at the same time.
>>
>>> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>
>>> -- compatible        : compatible list, contains 2 entries, first is
>>> -		 "fsl,CHIP-dma", where CHIP is the processor
>>> -		 (mpc8349, mpc8360, etc.) and the second is
>>> -		 "fsl,elo-dma"
>>> +- compatible        : must include "fsl,elo-dma"
>>
>> Why remove the list of supported compatible values. Lately it seems that
>> we're moving towards listing more/all the values rather than removing
>> their documentation...
> 
> Previous versions had language that required fsl,CHIP-dma for 83xx (and
> maybe 85xx?) but not the new chip.  I asked for it to be consistent.
> The reason that 83xx still has fsl,CHIP-dma is not because of anything
> special to 83xx, but that most other chips with this device have been
> converted to dtsi and it's much more of a pain to specify the specific
> SoC in that context.  The existing language does not match actual device
> trees when it comes to 85xx.
> 
> Plus, the exact SoC name is of dubious value for integrated devices.  It
> doesn't uniquely identify the hardware because different versions of the
> SoC could have different versions of the subdevice.  As such, on our
> chips we've been moving away from including a compatible that specifies
> the exact SoC.  If it turns out we made a mistake in naming different
> versions of the device, or if there are errata, the exact SoC can still
> be determined at runtime using SVR.

OK, if there's some alternative run-time way of enabling chip-specific
quirking, it's probably fine to remove the extra compatible values.

Now, that does rather assume that this DMA IP block will only ever be
used within SoCs that have that SVR concept, but perhaps if that's ever
not the case, we can simply go back to requiring extra compatible values
in those specific cases?
