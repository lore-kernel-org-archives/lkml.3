Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3EPLjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:39:16 -0400
Received: from smtp-out-163.synserver.de ([212.40.185.163]:1137 "EHLO
	smtp-out-161.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752393Ab3EPLjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:39:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28217
Message-ID: <5194C54C.10300@metafoo.de>
Date: Thu, 16 May 2013 13:38:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH] dma: of: Make of_dma_simple_xlate match on DMA device
 and channel ID
References: <1368624449-29003-1-git-send-email-laurent.pinchart@ideasonboard.com> <3106852.EdI2KVGSEm@avalon> <5193A113.4050301@metafoo.de> <16693906.m6Wa34B7F1@avalon>
In-Reply-To: <16693906.m6Wa34B7F1@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:30 PM, Laurent Pinchart wrote:
> Hi Lars-Peter,
> 
> On Wednesday 15 May 2013 16:52:03 Lars-Peter Clausen wrote:
>> On 05/15/2013 03:55 PM, Laurent Pinchart wrote:
>>> On Wednesday 15 May 2013 15:39:09 Lars-Peter Clausen wrote:
>>>> On 05/15/2013 03:27 PM, Laurent Pinchart wrote:
>>>>> When translating a DT DMA channel specifier, the most common use case is
>>>>> to match the DMA channel based on the channel DMA engine and channel ID.
>>>>> Modify the of_dma_simple_xlate() function to do so, simplifying the API
>>>>> for DMA engine drivers.
>>>>>
>>>>> There is no need to check the DMA cells count in the filter function as
>>>>> the check is already performed by the caller in of_dma_get_controller().
>>>>>
>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> Hi,
>>>>
>>>> I've submitted a very similar patch some time ago, see
>>>> https://lkml.org/lkml/2013/3/25/250
>>>
>>> Thanks. So my patch makes at least some sense :-)
>>>
>>> I had the impression that this is what omap-dma needs as well, hence the
>>> modification to the existing xlate function. I'm fine with a separate
>>> function as well if the current code covers different use cases.
>>
>> My first attempt was to modify simple_xlate function, but I think it didn't
>> work for all users (some of which aren't applied yet), so I added a separate
>> function.
> 
> OK. Do you plan to push your patch to mainline ? You can add my
> 

Yes, I already submitted it for mainline inclusion. Waiting for Vinod to
either apply or comment on it.

> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

