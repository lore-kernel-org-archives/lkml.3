Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab3HIPCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:02:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55696 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064Ab3HIPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:02:07 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-60-5205046d989f
From: Tomasz Figa <t.figa@samsung.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Grant Grundler <grundler@chromium.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 07/16] iommu/exynos: support for device tree
Date: Fri, 09 Aug 2013 17:02:02 +0200
Message-id: <33568604.vCtP4hvQ1q@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <CAL_JsqKM_YP0Cj3Uo7TeCVcKcbzzsuK3yxTSn6pG8qGFOnZAiA@mail.gmail.com>
References: <002b01ce941b$160a88a0$421f99e0$@samsung.com>
 <20130809153730.83d3a5ba419def5424bcbb0e@samsung.com>
 <CAL_JsqKM_YP0Cj3Uo7TeCVcKcbzzsuK3yxTSn6pG8qGFOnZAiA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xa7q5LKxBBqefKlrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktvn/7xmZx8k8vo0XL9V4mi1W7/jA6CHo8OTiPyWN2w0UWj52z7rJ73Lm2h83j/KY1zB6b
	l9R7TL6xnNGjb8sqRo/Pm+Q8rhw9wxTAFcVlk5Kak1mWWqRvl8CVsX1xH2PBTIGKBa2zmBoY
	T/J0MXJySAiYSKxrX8oGYYtJXLi3Hsjm4hASWMoocfXBXlYIp4tJ4srPAywgVWwCahKfGx6B
	dYgIqEt8W34crINZ4AyrxKZtl5lBEsICzhKzV59hBbFZBFQlDu1uZQKxeQW0JHbt/sMOYvMD
	Nb/b9hQozsEhKuAmMeFjPkiYUyBYovHzVSaIxTsYJeZdfMwK0Sso8WPyPbAjmAXkJfbtn8oK
	YWtJrN95nGkCo+AsJGWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZITH7d
	wbj0mNUhRgEORiUe3gm/WIKEWBPLiitzDzFKcDArifD+/gkU4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwGjxKf/XRK1gZa4/bo/Tj112v7W27oWZlJKl9/W/HicbP4qt/7ZcqCP4sAhPwqyt/n8f
	3j295g3HpJPLFszUtvSxbUtjrODolg6p2PJHP+OtqEPWwyq5ew0Ptp9fFts563O1lQ2ja6RO
	xap1+evclk5dEFB6xbr27K3O/AYX6bZ33D+c/n2Vs1diKc5INNRiLipOBABfgu/UpwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 of August 2013 08:28:09 Rob Herring wrote:
> On Fri, Aug 9, 2013 at 1:37 AM, Cho KyongHo <pullip.cho@samsung.com> 
wrote:
> > On Fri, 09 Aug 2013 00:41:25 +0200, Tomasz Figa wrote:
> >> Hi KyongHo,
> >> 
> >> On Thursday 08 of August 2013 18:38:49 Cho KyongHo wrote:
> >> > This commit adds device tree support for System MMU.
> >> > This also include the following changes and enhancements:
> >> > 
> >> > * use managed device helper functions.
> >> > Simplyfies System MMU device driver.
> >> > 
> >> > * use only a single clock descriptor.
> >> > System MMU device descriptor is seperate if it is imposible to make
> >> > a single clock descriptor to make a device descriptor for a group of
> >> > System MMUs.
> >> > 
> >> > * removed dbgname member from sysmmu_drvdata structure.
> >> > debugging kernel message for a System MMU is distinguisheable with
> >> > the
> >> > name of device descroptors.
> >> 
> >> Please put all these three changes in separate patches. This patch is
> >> hard to review with all the changes mixed together...
> 
> Agreed.
> 
> > Ok.
> > 
> >> In addition, I believe this is the patch that should be adding device
> >> tree binding documentation, not the 6/16 one, as this is where
> >> actually support for this binding gets added to the kernel.
> > 
> > Oh, I didn't know that devicetree binding description and
> > implementation need to be in the same patch.
> > I will do as you advised.
> 
> Actually, I prefer the binding docs be separate patches. The reason
> being so we can get closer to having them in a separate repository.
> Also, then the binding can be acked separately from the kernel
> implementation using the binding.

OK. This is a good point. So maybe let's fully define this order to be as 
following (and have first best practice for the DT binding best practices 
that need to be defined):

Bindings documentation should be added with a separate patch, before any 
user of these bindings is introduced.

What do you think?

Best regards,
Tomasz

