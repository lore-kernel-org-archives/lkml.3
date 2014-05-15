Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaEOJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:01:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37203 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaEOJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:01:14 -0400
Message-ID: <53748227.3050809@ti.com>
Date: Thu, 15 May 2014 14:30:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Arnd Bergmann <arnd@arndb.de>
CC: <joelf@ti.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>, "Mattson, Mark" <m-mattson@ti.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 3/5] dt/bindings: ti,edma: Remove redundant properties
 from documentation
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com> <1399977032-26469-4-git-send-email-peter.ujfalusi@ti.com> <7468082.VY82PIo3ZY@wuerfel> <5374784B.7020608@ti.com>
In-Reply-To: <5374784B.7020608@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ DT bindings maintainers

On Thursday 15 May 2014 01:48 PM, Peter Ujfalusi wrote:
> On 05/15/2014 11:01 AM, Arnd Bergmann wrote:
>> On Tuesday 13 May 2014 13:30:30 Peter Ujfalusi wrote:
>>> From CCCFG register of eDMA3 we can get all the needed information for the
>>> driver about the IP:
>>> Number of channels: NUM_DMACH
>>> Number of regions: NUM_REGN
>>> Number of slots (PaRAM sets): NUM_PAENTRY
>>> Number of TC/EQ: NUM_EVQUE
>>>
>>> The ti,edma-regions; ti,edma-slots and dma-channels in DT are
>>> redundant since the very same information can be obtained from the HW.
>>> The mentioned properties can be removed from the binding document.
>>>
>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>
>> I wonder if we should keep them listed as "optional" properties so you
>> can have a dtb file that still works with older kernels which need them.
>>
>> What you do is an incompatible change to the binding, which we shouldn't
>> do lightly. Any new dts files don't need this information of course, but
>> as a general rule, I'd rather keep things like this around unless we
>> already have to enforce an ABI break that is well documented.
> 
> We could keep them as optional, or to be precise: ignored properties since we
> are not going to even look at them in the future.
> But I do not really see the reason to do so. With this change new kernels will
> boot with old DTB - if it can not be changed which I have not seen yet. Sure
> old kernel would not boot with this change, but why would you downgrade the
> kernel and update the DTB on a board?
> Bisecting is not a good reason since the bug you might be hunting for could be
> in the DTS or in the kernel code so you need to update both of them to be sure
> you reach the commit you are looking for.

Agree with Peter here. The bisecting corner case can hopefully be
handled by appended DTB even if the original DTB was ROMed.

Thanks,
Sekhar
