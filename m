Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaCRFqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:46:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15019 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaCRFqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:46:01 -0400
X-AuditID: cbfee68e-b7f566d000002344-f3-5327dd964638
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Inki Dae'" <inki.dae@samsung.com>,
        "'Daniel Kurtz'" <djkurtz@chromium.org>
Cc: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Seung-Woo Kim'" <sw0312.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'DRI mailing list'" <dri-devel@lists.freedesktop.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1395026886-14325-1-git-send-email-djkurtz@chromium.org>
 <CAAQKjZMeeyD+6fhCaGk9qzX0oLTS=vHU86Y7gF9ZnbwcpTT7Kg@mail.gmail.com>
In-reply-to: <CAAQKjZMeeyD+6fhCaGk9qzX0oLTS=vHU86Y7gF9ZnbwcpTT7Kg@mail.gmail.com>
Subject: RE: [PATCH] drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c
Date: Tue, 18 Mar 2014 14:45:57 +0900
Message-id: <01a301cf426d$55d080b0$01718210$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJpimB5+lyE73JtfJEi/Aan+2yVSwIvY/YsmaBKcvA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zY91pd9WDDZZM5bZonDGf1eLK1/ds
	FpPuT2CxONv0ht1i0+NrrBaXd81hs5hxfh+Txck/vYwWMya/ZHPg9JjdcJHF4861PWwe97uP
	M3lsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBkb/y5jLZjHWnHnxzKWBsZZLF2MnBwS
	AiYSffMmQtliEhfurWfrYuTiEBJYxijxumMOG0zRot0zWCESixgl9n2bxQjh/GWU2L5lBVg7
	m4CGxOH3z9hBbBEBH4lVU/qYQYqYBVYwSfx99Qyqo5tRYveWQ4wgVZwCwRI75v8Bs4UF/CQO
	z/wMNImDg0VAVeLbYVEQk1fAUmLXfn+QCl4BQYkfk++B7WIW0JJYv/M4E4QtL7F5zVtmiEsV
	JHacfc0IcYOVxNUz36HqRST2vXgHdoKEQCuHxLnTj8GKWAQEJL5NPgS2VkJAVmLTAag5khIH
	V9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoREd98O
	xpsHrA8xJgOtn8gsJZqcD0wOeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBkZ2ba81bMflZHJ1OS7Ns7kTJ6bAf4X7F3FP567nHFNZjj/fNlLni
	NXvNrbKNAdefFcyZxXPW7VD5jOLv/5O56vJD5zB4XJkw6VX1xTNT8qSlk6e8uMt3kFnMVTCM
	s+KbSCzHC0u35tmfxN4/n28lcGVm6h+J8Pjvf6ON7v3ed6GKed+Ms7f7PZRYijMSDbWYi4oT
	AYlM8lwEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd1pd9WDDU5fY7NonDGf1eLK1/ds
	FpPuT2CxONv0ht1i0+NrrBaXd81hs5hxfh+Txck/vYwWMya/ZHPg9JjdcJHF4861PWwe97uP
	M3lsXlLv0bdlFaPH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz
	Nv5dxlowj7Xizo9lLA2Ms1i6GDk5JARMJBbtnsEKYYtJXLi3nq2LkYtDSGARo8S+b7MYIZy/
	jBLbt6wA62AT0JA4/P4ZO4gtIuAjsWpKHzNIEbPACiaJv6+eQXV0M0rs3nKIEaSKUyBYYsf8
	P2C2sICfxOGZn4EmcXCwCKhKfDssCmLyClhK7NrvD1LBKyAo8WPyPbBdzAJaEut3HmeCsOUl
	Nq95ywxxqYLEjrOvGSFusJK4euY7VL2IxL4X7xgnMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4NTxTHoH46oGi0OMAhyMSjy8L9jUg4VYE8uKK3MPMUpw
	MCuJ8C6dDBTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGBayyuJNzQ2MTOyNDKzMDIxNydN
	WEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxlo3ZnsJ2TNTpVtW3GqY/L74Y2UTW3Lk0Znd
	gvPPu0Td6uaOaYzeekagP2LNnj0HtAs3Pw+J+vXk60/XuOneYn+fXHx4//YR0fmmq39OXXkw
	5kx0ZO/qLdWPa86cPbhh3qzUG/vO25s4zj472fqb411P0euKZg5vn7jOEJBdGLDyTDbztfPd
	j+8psRRnJBpqMRcVJwIAN10BDGEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inki Dae wrote:
> 
> Applied.
> 
> Thanks,
> Inki Dae
> 
> 2014-03-17 12:28 GMT+09:00 Daniel Kurtz <djkurtz@chromium.org>:
> > The following commit [0] fixed a use-after-free, but left the subdrv
> open
> > in the error path.
> >
> > [0] commit 6ca605f7c70895a35737435f17ae9cc5e36f1466
> > drm/exynos: Fix freeing issues in exynos_drm_drv.c
> >
> > Change-Id: I452e944bf090fb11434d9e34213c890c41c15d73

This should be removed when Inki apply this.

Thanks,
Kukjin

> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/gpu/drm/exynos/exynos_drm_drv.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)

