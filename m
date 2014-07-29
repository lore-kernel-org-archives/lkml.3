Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaG2OrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:47:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13762 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaG2OrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:47:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e9-53d7b3e8a650
Message-id: <53D7B3E8.6070906@samsung.com>
Date: Tue, 29 Jul 2014 16:47:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 RESEND 2/4] drivers: of: initialize and assign reserved
 memory to newly created devices
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
 <1405326487-15346-3-git-send-email-m.szyprowski@samsung.com>
 <20140728141700.55FC4C408EA@trevor.secretlab.ca>
In-reply-to: <20140728141700.55FC4C408EA@trevor.secretlab.ca>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHec9lOy5np6XxqqC46IuhOQh5CYuooJeCKIQQyWzp8QJOx6aS
	EiRpQSs1VLwMncZakaxNtlI3I3V5K+2Gy3HUtBQqE7PSRKcbue2L337P8//xfz48DCnpoCKY
	3PxCTpUvz5MKRNSod9gZ98PqSk6o9O5GzWajAM0v6ijkqRkSouVH9wBqHXhHo76tboCe3C0X
	IJvpF0BddxqFaNX5lUCW+QkajdubBahjoZ9AbcMVNNpqiELGAb0QebosFDI3LlLoQeusEC38
	GaGOh2KjzgjwprsG4PGqSgLbtJ+FWLPkJPD0xAsBHmncpPAXh5XC1oc38JR3nsSmrZ8ErvYk
	4BZ7FcBVz9oBXrFEnd+dKkrK5PJyiznVoWNXRDlddheh5JlrG/w3ugy4BRoQxED2MHT188IA
	74MfZszbexEjYQ0A9rx/SweGvwB6dZ1+S8zGQn3vIOFjij0Av5v7SB8LWBnULGn8rWHsJThW
	uUIG/D1wvXaG8nEoq4ST7nJ/KcnW0dA4qvcHe7eDlX9PicA1O4DVhmp/EMQehb+bbtM+JtlE
	OFdhIgMcDa3GJfI+YLU7jmh3aNodWhsg20EYV5ShVF/NVsji1XKFuig/Oz6jQGEBgS+vdgP9
	0BEHYBkgDRan8M5kCS0vVpcoHAAypDRUfMrsSpaIM+UlpZyqIF1VlMepHYBggiLKwON6x+qF
	Zp7kvGsXs5YPxs1lJXqvx5UWRhouL2aOf4Lu8FrzacWZj7YGlFYwaX8OTAZJjCy+81VCNNdi
	m93Vu0GnKSOHZqesNfu5fv5ES/dYSvu5TV5X+bLea3iNktYG1sOng8t4+cnUszGSwTe2kNLC
	9JusxDPXVNdzK0RKqXPkslhSpZb/B43dXELDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-28 16:17, Grant Likely wrote:
> On Mon, 14 Jul 2014 10:28:05 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> Use recently introduced of_reserved_mem_device_init() function to
>> automatically assign respective reserved memory region to the newly created
>> platform and amba device.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> I'm still not okay with this patch. I don't think it is appropriate to
> add the hook into the generic path that gets used for every platform
> device. The devices that need reserved memory should explicitly request
> it, and any setup be done at that time.

Okay... I thought that it will be easier to have it done in generic 
code, if You don't
think so, then I give up and we will add it in all drivers requiring 
such memory regions.

What about patch 3/4 and 4/4? Would it be possible to have your ack to 
get them merged?
Right now patch 4/4 depends on changes from akpm tree, so it will be 
best to merge them
to akpm tree.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

