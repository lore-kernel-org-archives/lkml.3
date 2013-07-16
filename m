Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3GPNHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:07:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21023 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3GPNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:07:48 -0400
X-AuditID: cbfee691-b7fef6d000002d62-e9-51e545a316c4
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>
Cc: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>
References: <002b01ce797b$44d4ad10$ce7e0730$@samsung.com>
 <1933986.4vddYccClk@amdc1032> <009a01ce814d$840b48c0$8c21da40$@samsung.com>
 <CANEJEGs_8a9dPCYtDT8u2NEv5HUUD5gcdmRmbsrKU-_aagztgg@mail.gmail.com>
In-reply-to: <CANEJEGs_8a9dPCYtDT8u2NEv5HUUD5gcdmRmbsrKU-_aagztgg@mail.gmail.com>
Subject: RE: [PATCH v7 3/9] iommu/exynos: fix page table maintenance
Date: Tue, 16 Jul 2013 22:07:46 +0900
Message-id: <002101ce8225$775a71e0$660f55a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQLNCGHc5Tw70Lg/Z1yb1OqFMpmE+gJtmRjqAZnUgQQCSj+ZVJc3rCYw
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+Zse5i16eBBv/+cVpsnLGe1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLPY9Pgaq8XlXXPYLGac38dkcWHFRnaLKYsOs1q0
	XO9lcuD1eHJwHpPH7IaLLB53ru1h89i8pN5j8o3ljB59W1YxenzeJBfAHsVlk5Kak1mWWqRv
	l8CVsbbzOmPBe/aKZScXMDcwTmbrYuTkkBAwkTjyeCeULSZx4d56IJuLQ0hgGaPE6WfdTDBF
	T+98ZIRILGKUmLz3PxOE85dRYlL/FVaQKjYBLYnVc48DVXFwiAjoSMxfYg9SwyxwkEViwoM3
	UGPPMUpsWHabBaSBUyBY4vmqf4wgtrCAi8SZ6wuZQWwWAVWJ9f2zwWp4BSwllqxdBmULSvyY
	fA/MZhZQl5g0bxEzhC0vsXnNW2aIUxUkdpx9zQgRF5HY9+IdmC0i4Cbx/dZKdpAjJASWckjs
	frESapmAxLfJh1hArpYQkJXYdABqjqTEwRU3WCYwSsxCsnoWktWzkKyehWTdAkaWVYyiqQXJ
	BcVJ6UWmesWJucWleel6yfm5mxgh6WDiDsb7B6wPMSYDrZ/ILCWanA9MJ3kl8YbGZkYWpiam
	xkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNwWGXw9j+f+6u08RuxS
	hkwhTVesXJNvi4Q7lDZHhE98yDz1PdPZexfOusUd5JtonLeyO/Ek3/WdDedMZnbtZPiod2l9
	8TMvEfltBXM/NLZqT059+3ZvkcBm7hmfb3isfvi93Pvwmr1/BN5lt3z/7//1rKNVa5XYtkLn
	pWp6r2YkeZ3b/ch7Q5cSS3FGoqEWc1FxIgD5PmNbHQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAd3Frk8DDXqus1hsnLGe1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLPY9Pgaq8XlXXPYLGac38dkcWHFRnaLKYsOs1q0
	XO9lcuD1eHJwHpPH7IaLLB53ru1h89i8pN5j8o3ljB59W1YxenzeJBfAHtXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK2SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNt53XGgvfsFctOLmBuYJzM1sXIySEhYCLx9M5H
	RghbTOLCvfVAcS4OIYFFjBKT9/5ngnD+MkpM6r/CClLFJqAlsXrucaAODg4RAR2J+UvsQWqY
	BQ6ySEx48Aaq+xyjxIZlt1lAGjgFgiWer/oHtkJYwEXizPWFzCA2i4CqxPr+2WA1vAKWEkvW
	LoOyBSV+TL4HZjMLqEtMmreIGcKWl9i85i0zxKkKEjvOvmaEiItI7HvxDswWEXCT+H5rJfsE
	RqFZSEbNQjJqFpJRs5C0L2BkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnGyeSe9gXNVg
	cYhRgINRiYf3IOeTQCHWxLLiytxDjBIczEoivCGmTwOFeFMSK6tSi/Lji0pzUosPMSYDfTqR
	WUo0OR+YCPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgTF/
	s+C8FUfKlbXOtERpJi63tDnMpfT9e/MxVw/23jMH34lJ3Hhz2C2pTMNnJa/ewztzFP9v4pLy
	WSQds+vvlk0nNGzuvJ53T8E1QG+1RIWLzuyPdxb8WpkUaZ63slUwPXuebb+LSb7ps6L4VU7e
	u/daF7fEp6bdtTnwRO5v5JNd6gx88/xXWCuxFGckGmoxFxUnAgB4mZ0tegMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Tuesday, July 16, 2013 1:19 AM
> 
> On Mon, Jul 15, 2013 at 4:21 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> ...
> >> Maybe you could add LV1TABLE_SIZE define and use it here (there is
> >> already a LV2TABLE_SIZE define)?
> >
> > Yes. But, LV2TABLE_SIZE is used in more places than one.
> > I do not feel that it is needed to define LV1TABLE_SIZE for the single line.
> 
> Cho,
> #define's are part of the code "documentation". Doesn't really matter
> how often it's used. I think Bartlomiej's suggestion is a good one.
> 
> Key is to use "consistent" names so they makes sense to someone not
> familiar with the code. In this case, we want to show this use is the
> same way LV2TABLE_SIZE is used and serves the same purpose.
> 
Ok.
I agree the error handling code is not pretty to understand.
I will change it in the next patch.

> cheers.
> grant

Thank you.

Cho KyongHo.

