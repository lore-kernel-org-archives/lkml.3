Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965841AbaFRKMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:12:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55490 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbaFRKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:11:59 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-2b-53a165ebb7b0
Message-id: <53A165EA.9000806@samsung.com>
Date: Wed, 18 Jun 2014 12:11:54 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.kernel,gmane.linux.kernel.samsung-soc,gmane.linux.ports.arm.kernel,gmane.linux.drivers.devicetree
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, mturquette@linaro.org
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        kgene.kim@samsung.com, sw0312.kim@samsung.com, rob.herring@calxeda.com,
        kishon@ti.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        sylvester.nawrocki@gmail.com
Subject: Re: [PATCH 1/4] clk: propagate parent change up one level
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
 <1396623201-26000-2-git-send-email-t.stanislaws@samsung.com>
 <5344198B.2030604@samsung.com> <536176DD.5020507@gmail.com>
In-reply-to: <536176DD.5020507@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Zd3XqQuDDU78MrK4te4cq8X8I0Di
	ytf3bBa9C66yWVx42sNmcbbpDbvFpsfXWC0u75rDZjHj/D4mi6cTLrJZHF5xgMlixuSXbBbz
	Pu9kslg/4zWLxapdfxgd+D0WfL7C7rFz1l12jzvX9rB53O8+zuSxeUm9R9+WVYwex29sZ/L4
	vEkugCOKyyYlNSezLLVI3y6BK+P1lZWMBQvFK+Y+4G5g7BHqYuTkkBAwkfiw/TEbhC0mceHe
	eiCbi0NIYCmjxKo5W5ggnM+MEkuuPmcBqeIV0JI4ePMJmM0ioCrx8kUfI4jNBjTp2JLPQDYH
	h6hAhMTjC0IQ5YISPybfYwGZwycwjVFiyhSIoSICBxklnlzsZgVxmAW+MEp8mfyVFaRFWMBJ
	4kbXBqg7jjJK7Ni1H2wFp4CmRMeT+8wgNrOAjsT+1mlsELa8xOY1b5knMArOQrJyFpKyWUjK
	FjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibevOxiXHrM6xCjAwajEw9twbUGwEGti
	WXFl7iFGCQ5mJRFe5cSFwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYExcZ+Wb9u6fSpadz9cmH
	ahcJ4bg4sy3bp/f99WRTtPbb+T5xYaTziynTN/JFWcyKulC6s3LDirqjVc/ten4KrjJpdJ3O
	9PxoiM5XtvkhRsIHZqXb68udeF24sGKC/g3GxPKAnB2CqwMnXUh8qKf4W5Dp+NXf9Y2rFIJ6
	w0tS/81udfm0ZIe1EktxRqKhFnNRcSIA1EJIpZUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
Do you have any comments about this patch?
The patch is needed to provide a clean fix for recently
broken support for HDMI on Exynos4210 SoC in mainline.

Regards,
Tomasz Stanislawski


On 05/01/2014 12:19 AM, Tomasz Figa wrote:
> Mike,
> 
> On 08.04.2014 17:45, Tomasz Figa wrote:
>> Hi,
>>
>> On 04.04.2014 16:53, Tomasz Stanislawski wrote:
>>> This patch adds support for propagation of setup of clock's parent one
>>> level
>>> up.
>>>
>>> This feature is helpful when a driver changes topology of its clocks
>>> using
>>> clk_set_parent().  The problem occurs when on one platform/SoC
>>> driver's clock
>>> is located at MUX output but on the other platform/SoC there is a
>>> gated proxy
>>> clock between the MUX and driver's clock.  In such a case, driver's
>>> code has to
>>> be modified to use one clock for enabling and the other clock for
>>> setup of a
>>> parent.
>>>
>>> The code updates are avoided by propagating setup of a parent up one
>>> level.
>>>
>>> Additionally, this patch adds CLK_SET_PARENT_PARENT (sorry for naming)
>>> flag to
>>> inform clk-core that clk_set_parent() should be propagated.
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>> ---
>>>   drivers/clk/clk.c            |    6 ++++++
>>>   include/linux/clk-provider.h |    1 +
>>>   2 files changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>>> index dff0373..53bbfda 100644
>>> --- a/drivers/clk/clk.c
>>> +++ b/drivers/clk/clk.c
>>> @@ -1737,6 +1737,12 @@ int clk_set_parent(struct clk *clk, struct clk
>>> *parent)
>>>
>>>       /* try finding the new parent index */
>>>       if (parent) {
>>> +        if ((clk->flags & CLK_SET_PARENT_PARENT)
>>> +            && clk->num_parents == 1) {
>>> +            ret = clk_set_parent(clk->parent, parent);
>>> +            goto out;
>>> +        }
>>> +
>>>           p_index = clk_fetch_parent_index(clk, parent);
>>>           p_rate = parent->rate;
>>>           if (p_index < 0) {
>>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>>> index 5119174..daa0b03 100644
>>> --- a/include/linux/clk-provider.h
>>> +++ b/include/linux/clk-provider.h
>>> @@ -30,6 +30,7 @@
>>>   #define CLK_GET_RATE_NOCACHE    BIT(6) /* do not use the cached clk
>>> rate */
>>>   #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate
>>> change */
>>>   #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk
>>> accuracy */
>>> +#define CLK_SET_PARENT_PARENT    BIT(9) /* propagate parent change up
>>> one level */
>>>
>>>   struct clk_hw;
>>>   struct dentry;
>>>
>>
>> This would be very useful, at least on Exynos platforms, with
>> mux-div-gate clock paths. PARENT_PARENT sounds a bit funny, though.
>>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> Your opinion on this would be greatly appreciated.
> 
> Best regards,
> Tomasz

