Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab3BSRGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:06:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49036 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab3BSRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:06:20 -0500
Message-ID: <5123B108.1010207@wwwdotorg.org>
Date: Tue, 19 Feb 2013 10:06:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dma: tegra: assume CONFIG_OF
References: <1360965237-14857-1-git-send-email-swarren@wwwdotorg.org> <CAA9_cme3e-VWFs+5o6g88dXmURsjojT08o9Cw+=r7=AfRKz5gQ@mail.gmail.com> <20130217150735.GK29960@intel.com>
In-Reply-To: <20130217150735.GK29960@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 08:07 AM, Vinod Koul wrote:
> On Fri, Feb 15, 2013 at 02:18:59PM -0800, Dan Williams wrote:
>> On Fri, Feb 15, 2013 at 1:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> Tegra only supports, and always enables, device tree. Remove all ifdefs
>>> and runtime checks for DT support from the driver.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> Acked-by: Dan Williams <djbw@fb.com>
>>
>> ..adding Vinod.
>
> I think it should assume CONFIG_DMA_OF?

I'm not quite sure what you're saying. There are no ifdefs in the driver
related to CONFIG_DMA_OF, so there's no code (ifdefs) that could benefit
from (be removed due to) assuming that.

Do you mean this driver should be updated to support the generic DMA DT
bindings? Yes, that's true. However, a patch to do so would be
completely unrelated. We've been holding off doing such a conversion
until the dmaengine core support for CONFIG_DMA_OF is in the kernel, so
we can use it.
