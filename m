Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaKNHdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:33:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16792 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbaKNHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:33:03 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-02-5465b02cd347
Content-transfer-encoding: 8BIT
Message-id: <1415950378.25732.0.camel@AMDC1943>
Subject: Re: [PATCH v2 2/2] drm/exynos/dsi: Add runtime PM so LCD power domain
 could be turned off
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Fri, 14 Nov 2014 08:32:58 +0100
In-reply-to: <54656E9A.8040702@samsung.com>
References: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
 <1415368439-23642-3-git-send-email-k.kozlowski@samsung.com>
 <54656E9A.8040702@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xq7o6G1JDDD61sFrcWneO1aL33Ekm
	i40z1rNaXPn6ns1i5RQWi0n3J7BYvLh3kcWid8FVNounmx8zWZxtesNusenxNVaLy7vmsFnM
	OL+PyWLtkbvsFjMmv2Rz4PfYtKqTzWP7twesHve7jzN5bF5S79G3ZRWjx/Eb25k8Pm+SC2CP
	4rJJSc3JLEst0rdL4MrY+GwWY8Fk3op/XdENjMc5uxg5OSQETCRaZrxmh7DFJC7cW8/WxcjF
	ISSwlFHi58TjzCAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP1nRonjnQtYIer1
	JTYfuMUEYgsLpEgcfPOQEcRmEzCW2Lx8CRuILSKgLLFqXzs7SDOzwFYWid2fv7GDLGARUJV4
	N7cIpIZTQFvi8bPVUActY5To6bvGClIjAdTc2O82gVFgFpLzZiGcNwvJeQsYmVcxiqaWJhcU
	J6XnGuoVJ+YWl+al6yXn525ihETQlx2Mi49ZHWIU4GBU4uE1KEgNEWJNLCuuzD3EKMHBrCTC
	u2A2UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjnWA9C9vXRScv3rNIOn92/gbtnRuD/p29/sDq
	/PNzyz7fNHdalmjwqG3bRB3F/z5c4kbWr81+i06aJ5J57eV+XRXjPeId7EuCG499KdnCv/xW
	yMUUgZd/9wgvjmhcnzdZZk7CgvbzJe/+XNadm1t7ZNHbZsvPovZFFvlslWIGIVF7t7s33fuj
	o8RSnJFoqMVcVJwIAIsOK85+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-14 at 11:53 +0900, Inki Dae wrote:
> On 2014년 11월 07일 22:53, Krzysztof Kozlowski wrote:
> > Add runtime Power Management to the Exynos DSI driver so the LCD power
> > domain could be turned off.
> > 
> > This slightly reduces the energy consumption when screen is completely
> > turned off. On Trats2 board when the system was idle the energy
> > consumption dropped by 1% (from 92.2 mA to 91.1 mA).
> > 
> > Before the patch:
> > $ cat cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
> > lcd0-power-domain               on
> >     /devices/11c00000.fimd                              suspended
> >     /devices/11c80000.dsi                               unsupported
> > 
> > After applying the patch:
> > lcd0-power-domain               off
> >     /devices/11c00000.fimd                              suspended
> >     /devices/11c80000.dsi                               suspended
> 
> Reasonable but this patch incurs page flip test timeout like below,
> # modetest -v -s 15@12:720x1280
> trying to open device 'i915'...failed.
> trying to open device 'radeon'...failed.
> trying to open device 'nouveau'...failed.
> trying to open device 'vmwgfx'...failed.
> trying to open device 'omapdrm'...failed.
> trying to open device 'exynos'...success.
> setting mode 720x1280-0Hz@XR24 on connectors 15, crtc 12
> select timed out or error (ret 0)
> 
> I'm not sure why this issue is incurred with this patch even through
> this patch is reasonable and correct. So we need more checking.
> 
> P.S. I tested it on exynos-drm-next and m0 board.

Thanks for pointing this issue. I'll investigate it.

Best regards,
Krzysztof


