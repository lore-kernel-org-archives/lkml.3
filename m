Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaJ3Man (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:30:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10650 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052AbaJ3Maj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:30:39 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-89-54522f6d59bb
Message-id: <1414672235.23399.7.camel@AMDC1943>
Subject: Re: [RFT v3 06/14] regulator: max77802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Thu, 30 Oct 2014 13:30:35 +0100
In-reply-to: <54522D2C.9050002@collabora.co.uk>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
 <54522615.7040002@collabora.co.uk> <1414671037.23399.2.camel@AMDC1943>
 <54522D2C.9050002@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xq7q5+kEhBqubmSw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdY9C64ymZxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2Cxm
	nN/HZHH7Mq/F2iN32S1Od7M6CHi0NPewefx9fp3F4++qF8weO2fdZffYtKqTzePOtT1sHvNO
	BnpsXlLv0bdlFaPH501yAVxRXDYpqTmZZalF+nYJXBl3d3kVPOCt+PFzMmMDYyd3FyMHh4SA
	icTNtfFdjJxAppjEhXvr2boYuTiEBJYySrR/2soO4XxmlPj6r4URpIpXQF9i37xvzCC2sIC/
	RPffyawgNpuAscTm5UvYQGwRATuJG6sfMoM0MwscZpFY9OA6WIJFQFXi97t5LCA2J9CgY0cX
	scJtuNPyGWwDs4C6xKR5i5ghzlOWaOx3g1gsKPFj8j0WiBJ5ic1r3jJPYBSYhaRjFpKyWUjK
	FjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIibMvOxgXH7M6xCjAwajEw+uwMSBEiDWx
	rLgy9xCjBAezkgjvUZ2gECHelMTKqtSi/Pii0pzU4kOMTBycUg2Mjhsjn+qbdJgU/EvR8hA7
	9Ea7M8rxz6ltCn2bpVaf11GWPvLpcuykfMHfxoqTlv66oNT+kSHuX8/j/k7b8k5jw5Znz+4f
	OmSkfzvo9iqbrjfP+RmLfq66c0b1ckKr75z1s764X2s96LIws6HI51+2hMsZ2a9bfK+7cGse
	e6wQ8X7p7/THs/oUlViKMxINtZiLihMBgqQLgJECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-30 at 13:21 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/30/2014 01:10 PM, Krzysztof Kozlowski wrote:
> >> 
> >> I may be missing something but I don't understand why a compatible string
> >> for the regulators sub-node is needed. Isn't enough to just fill the
> >> .regulators_node field in the struct regulator_desc? e.g:
> >> 
> >>     .regulators_node = of_match_ptr("regulators") for max77802
> >>     .regulators_node = of_match_ptr("voltage-regulators") for max77686
> >> 
> >> AFAIU this should be enough for the core to extract the init_data and will
> >> make your change much more simpler and you can drop patches 1-3 and 13-14.
> >> 
> >> Or maybe I misread the regulator_of_get_init_data() function?
> > 
> > The regulator_of_get_init_data() searches from dev->of_node or its child
> > node.
> > 
> > But dev->of_node is NULL.
> > 
> > That's why of_compatible is needed.
> 
> Yes but regulator_register() does dev = config->dev and config->dev is set
> to config.dev = iodev->dev in the driver probe function which is the
> pdev->dev.parent (the PMIC struct device) that has an associated of_node.
> 
> So, regulator_of_get_init_data() will call of_get_child_by_name() passing
> the PMIC of_node and the sub-node name that contains the regulators. That
> is, whatever was set in desc->regulators_node and that should be enough.

I missed that one in max77802 (in max77686: config.dev = &pdev->dev).
Now I wonder if it is proper to attach regulators to driver's parent
device. Consider regulator_register, around line 3640:
	rdev->dev.parent = dev;
The parent of regulators will be equal to parent of regulator driver -
main MFD driver.

Best regards,
Krzysztof


