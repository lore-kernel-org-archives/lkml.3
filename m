Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaDILxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:53:09 -0400
Received: from mail.saftware.de ([83.141.3.46]:35030 "EHLO mail.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbaDILxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:53:07 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 07:53:07 EDT
Message-ID: <5345333D.4080505@saftware.de>
Date: Wed, 09 Apr 2014 13:47:09 +0200
From: Andreas Oberritter <obi@saftware.de>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
CC: kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, rahul.sharma@samsung.com
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com> <1396967856-27470-2-git-send-email-t.stanislaws@samsung.com> <534506B1.4040908@samsung.com>
In-Reply-To: <534506B1.4040908@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrzej,

On 09.04.2014 10:37, Andrzej Hajda wrote:
>> +static int exynos_phy_probe(struct platform_device *pdev)
>> +{
>> +	const struct of_device_id *of_id = of_match_device(
>> +		of_match_ptr(exynos_phy_of_match), &pdev->dev);
>> +	const u32 *offsets = of_id->data;
>> +	int count;
>> +	struct device *dev = &pdev->dev;
>> +	struct phy **phys;
>> +	struct resource *res;
>> +	void __iomem *regs;
>> +	int i;
>> +	struct phy_provider *phy_provider;
>> +
>> +	/* count number of phys to create */
>> +	for (count = 0; offsets[count] != ~0; ++count)
>> +		;
> 
> count = ARRAY_SIZE(offsets) - 1;

u32 *offsets is not an array.

Regards,
Andreas
