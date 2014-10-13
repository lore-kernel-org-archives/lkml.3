Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaJMIPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:15:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37593 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaJMIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:15:03 -0400
Message-ID: <543B8A02.5050106@codeaurora.org>
Date: Mon, 13 Oct 2014 01:14:58 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC 1/4] dma-buf: Add constraints sharing information
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org> <1412971678-4457-2-git-send-email-sumit.semwal@linaro.org> <20141011185502.GH26941@phenom.ffwll.local>
In-Reply-To: <20141011185502.GH26941@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 11:55 AM, Daniel Vetter wrote:
> On Sat, Oct 11, 2014 at 01:37:55AM +0530, Sumit Semwal wrote:
>> At present, struct device lacks a mechanism of exposing memory
>> access constraints for the device.
>>
>> Consequently, there is also no mechanism to share these constraints
>> while sharing buffers using dma-buf.
>>
>> If we add support for sharing such constraints, we could use that
>> to try to collect requirements of different buffer-sharing devices
>> to allocate buffers from a pool that satisfies requirements of all
>> such devices.
>>
>> This is an attempt to add this support; at the moment, only a bitmask
>> is added, but if post discussion, we realise we need more information,
>> we could always extend the definition of constraint.
>>
>> A new dma-buf op is also added, to allow exporters to interpret or decide
>> on constraint-masks on their own. A default implementation is provided to
>> just AND (&) all the constraint-masks.
>>
>> What constitutes a constraint-mask could be left for interpretation on a
>> per-platform basis, while defining some common masks.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-media@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linaro-mm-sig@lists.linaro.org
>
> Just a few high-level comments, I'm between conference travel but
> hopefully I can discuss this a bit at plumbers next week.
>
> - I agree that for the insane specific cases we need something opaque like
>    the access constraints mask you propose here. But for the normal case I
>    think the existing dma constraints in dma_params would go a long way,
>    and I think we should look at Rob's RFC from aeons ago to solve those:
>
>    https://lkml.org/lkml/2012/7/19/285
>
>    With this we should be able to cover the allocation constraints of 90%
>    of all cases hopefully.
>
> - I'm not sure whether an opaque bitmask is good enough really, I suspect
>    that we also need various priorities between different allocators. With
>    the option that some allocators are flat-out incompatible.
>

 From my experience with Ion, the bitmask is okay if you have only a few
types but as soon as there are multiple regions it gets complicated and
when you start adding in priority via id it really gets unwieldy.

Thanks,
Laura


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
