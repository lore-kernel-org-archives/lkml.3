Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbaJ3MxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:53:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28906 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbaJ3MxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:53:13 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-00-545234b5c6d4
Message-id: <1414673587.23399.13.camel@AMDC1943>
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
Date: Thu, 30 Oct 2014 13:53:07 +0100
In-reply-to: <54523224.3010407@collabora.co.uk>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
 <54522615.7040002@collabora.co.uk> <1414671037.23399.2.camel@AMDC1943>
 <54522D2C.9050002@collabora.co.uk> <1414672235.23399.7.camel@AMDC1943>
 <54523224.3010407@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Vd2tJkEhBhuWiltsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDL2X+xnK9ggWPFm0jP2BsY9vF2MnBwS
	AiYS66/+Y4GwxSQu3FvP1sXIxSEksJRR4vLiLiYI5zOjxI01p1lBqngFDCTmzJjDCGILC/hL
	dP+dDBZnEzCW2Lx8CRuILSJgJ3Fj9UNmkGZmgcMsEoseXAdLsAioSjw6txpsHaeAvkTT+61Q
	6/YwSSw4/YkJJMEsoC4xad4ioG4OoJuUJRr73SAWC0r8mHyPBaJEXmLzmrfMExgFZiHpmIWk
	bBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQmLt6w7GpcesDjEKcDAq8fBGHAsI
	EWJNLCuuzD3EKMHBrCTCe1QnKESINyWxsiq1KD++qDQntfgQIxMHp1QDo8yP/33Kt77mvZfa
	POlk+qfSHA1hO687AVpXtj2L/qa05+W/3mXXQ8zO94kynXM8deto7M2K9OVZa096zNfJYHdp
	rDrH+eTAfJctO2OUOqbM2Xvxj19q+/PPidw71DPn7v60aZVga4GbS/fXycGzdparT91mFm3k
	rTz3RNbim5/P8gmeit8SoajEUpyRaKjFXFScCAB3zD8MkwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-30 at 13:42 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/30/2014 01:30 PM, Krzysztof Kozlowski wrote:
> tor_of_get_init_data() function?
> >> > 
> >> > The regulator_of_get_init_data() searches from dev->of_node or its child
> >> > node.
> >> > 
> >> > But dev->of_node is NULL.
> >> > 
> >> > That's why of_compatible is needed.
> >> 
> >> Yes but regulator_register() does dev = config->dev and config->dev is set
> >> to config.dev = iodev->dev in the driver probe function which is the
> >> pdev->dev.parent (the PMIC struct device) that has an associated of_node.
> >> 
> >> So, regulator_of_get_init_data() will call of_get_child_by_name() passing
> >> the PMIC of_node and the sub-node name that contains the regulators. That
> >> is, whatever was set in desc->regulators_node and that should be enough.
> > 
> > I missed that one in max77802 (in max77686: config.dev = &pdev->dev).
> > Now I wonder if it is proper to attach regulators to driver's parent
> > device. Consider regulator_register, around line 3640:
> > 	rdev->dev.parent = dev;
> > The parent of regulators will be equal to parent of regulator driver -
> > main MFD driver.
> >
> 
> An early version of the max77802 regulator driver also set config.dev to
> &pdev->dev but then Mark asked me if I was sure that it should not be the
> MFD device instead.
> 
> I then read in regulator_register() that the rdev->dev.parent was set
> to the device passed in config.dev as you said so I was convinced that it
> should be the parent device instead.
> 
> Please take a look at [0] for that discussion.

To me a intuitive structure would be:
MFD device
  |
  - clock device
     |
     - clock1
     - clock2
  - regulator device
     |
     - LDO1
     - LDO2
etc.

This also maps to structure in DTS. dev_err* messages and any
allocations should be done on behalf of regulator device, not parent.

Various drivers do this differently... The wm8* drivers set it mostly to
parent (MFD)...

I do not insists, especially because using parent's device would make
this driver simpler.

Mark, maybe you could shed light on it?


Best regards,
Krzysztof


