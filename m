Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab3IKGcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:32:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36246 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3IKGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:32:05 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-87-52300e601917
Message-id: <52300E5A.7010202@samsung.com>
Date: Wed, 11 Sep 2013 08:31:54 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801
 Thunderbird/17.0.8
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] drivers: of: fix build break if asm/dma-contiguous.h is
 missing
References: <1378804400-31716-1-git-send-email-m.szyprowski@samsung.com>
 <522F76CF.6080907@gmail.com>
In-reply-to: <522F76CF.6080907@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t/xq7oJfAZBBjOf6lj8nXSM3WL+kXOs
	Fv1vFrJavDqzkc3iTW8Hi8XZpjfsFts7Z7BbfLnykMni8q45bBZPFp5hstjw8iCTxdLrF5ks
	FhxvYbX4M13O4tT1z2wWE6avZbH4/u0bm8Xf7ZtYLA6/aQcad7CNxWL9jNcsFqt2/WF0EPNY
	M28No8fvX5MYPV5PnsDocbmvl8lj56y77B63/z1m9rhyoonVY92fV0we/X8NPHZ+b2D36Nuy
	itHj50sdj8+b5Dw2zg0N4IvisklJzcksSy3St0vgyjhzWq7gBkfFh6OTmRoY37N1MXJySAiY
	SHxcOR3KFpO4cG89kM3FISSwlFGi//FMdginmUniz6mb7CBVvAJaEtu/fmcCsVkEVCWOTfzK
	CGKzCRhKdL3tApskKhAq0XNpOxtEvaDEj8n3WEBsEQF1iW/Lj4NtYBaYwSbReG8aM0hCWCBM
	4uiT/2BFQgLpEl1fZ4IN5RTQlNj0czPYIGYBM4lHLeuYIWx5ic1r3jJPYBSYhWTHLCRls5CU
	LWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREs9fdjAuPmZ1iFGAg1GJh/eGnH6QEGti
	WXFl7iFGCQ5mJRFeMXaDICHelMTKqtSi/Pii0pzU4kOMTBycUg2ModyqHK2p7cZH5r5Z/J75
	TaNyWIET73TnfUpW14zVV4vNzuiK5MvRupcRJqf9MK24bLHv35oP6+0fZ8aYBnwK2Zf36plK
	u+SL3qeP306u7DVMOPuu+q7SISkPjuOex/4HZbD5tdnlBr+OnhPDsfh188sfss55E9bv/BuV
	9ultfkdtrYvnmzdKLMUZiYZazEXFiQBWfRmIxQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 9/10/2013 9:45 PM, Rob Herring wrote:
> On 09/10/2013 04:13 AM, Marek Szyprowski wrote:
> > It is not needed to include asm/dma-contiguous.h header to compile
> > reserved memory initialization code, so remove it to avoid build break
> > on architectures without CMA support.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
>
> I can apply this or it can go with other CMA stuff.

I think it will be best if I push it to Linus asap to fix the build break
on arm64 and mips, introduced by my pull request. It is really strange that
I got no report from linux-next about that issue, although this patch was
there for about 2 weeks.

> Aren't there also some comments from Grant to address as well?

Right, I'm working on providing an update which will address the issues
pointed by Grant, but I got sick and had to take some days off. I still
didn't recover completely, but I hope I will manage to finish them by
the end of the week.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


