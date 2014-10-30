Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbaJ3MKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:10:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62473 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889AbaJ3MKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:10:42 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-39-54522abfa778
Message-id: <1414671037.23399.2.camel@AMDC1943>
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
Date: Thu, 30 Oct 2014 13:10:37 +0100
In-reply-to: <54522615.7040002@collabora.co.uk>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
 <54522615.7040002@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xa7r7tYJCDP5vV7HYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOY
	cX4fk8Xty7wWa4/cZbc43c3qIODR0tzD5vH3+XUWj7+rXjB77Jx1l91j06pONo871/awecw7
	GeixeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGXsvXySvWCjYMXTdeYNjAd4uxg5OSQE
	TCSmPz/CAmGLSVy4t56ti5GLQ0hgKaPE6ymroZzPjBIzvvYwglTxCuhLrDn1ggnEFhbwl+j+
	O5kVxGYTMJbYvHwJG4gtImAncWP1Q2aQZmaBwywSix5cB0uwCKhKtLfOB7I5ODiBBq28VQ2x
	YBWjxPT3X5lBapgF1CUmzVvEDFIjIaAs0djvBrFXUOLH5HssECXyEpvXvGWewCgwC0nHLCRl
	s5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREmdfdjAuPmZ1iFGAg1GJh9dhY0CI
	EGtiWXFl7iFGCQ5mJRFeQYWgECHelMTKqtSi/Pii0pzU4kOMTBycUg2MYiEa4qEOonevKuU6
	7f93W+ippuPxXevEV0Z2n2ZLb/Ke2JH5SHyzfOPrPasFlvdPLn1p+O+G20Th+0vn9PpNT17Q
	fbLvUOSbSc8/Trva9oE95/qtnZNP68SpRyjN7Ldfmvu56vMa4z9+NQc9Tja9qNV+z/N8bYHC
	pWORIR0zvt5aXxgxd9VtDyWW4oxEQy3mouJEAHUvjdSRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-10-30 at 12:50 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/30/2014 12:20 PM, Krzysztof Kozlowski wrote:
> >  static int max77802_pmic_probe(struct platform_device *pdev)
> >  {
> >  	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> > -	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
> >  	struct max77802_regulator_prv *max77802;
> > -	int i, ret = 0, val;
> > +	int i, val;
> >  	struct regulator_config config = { };
> >  
> > -	/* This is allocated by the MFD driver */
> > -	if (!pdata) {
> > -		dev_err(&pdev->dev, "no platform data found for regulator\n");
> > -		return -ENODEV;
> > -	}
> > -
> >  	max77802 = devm_kzalloc(&pdev->dev,
> >  				sizeof(struct max77802_regulator_prv),
> >  				GFP_KERNEL);
> >  	if (!max77802)
> >  		return -ENOMEM;
> >  
> > -	if (iodev->dev->of_node) {
> > -		ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
> > -		if (ret)
> > -			return ret;
> > +	if (!pdev->dev.of_node) {
> > +		/*
> > +		 * Backward DTS compatiblity where regulator driver had not
> > +		 * a compatible property for itself.
> > +		 */
> > +		if (!iodev->dev->of_node) {
> > +			dev_err(&pdev->dev, "No OF node for driver and its parent\n");
> > +			return -EINVAL;
> > +		}
> > +		pdev->dev.of_node = of_get_child_by_name(iodev->dev->of_node,
> > +								"regulators");
> > +		max77802->missing_of_node = true;
> >  	}
> 
> I may be missing something but I don't understand why a compatible string
> for the regulators sub-node is needed. Isn't enough to just fill the
> .regulators_node field in the struct regulator_desc? e.g:
> 
>     .regulators_node = of_match_ptr("regulators") for max77802
>     .regulators_node = of_match_ptr("voltage-regulators") for max77686
> 
> AFAIU this should be enough for the core to extract the init_data and will
> make your change much more simpler and you can drop patches 1-3 and 13-14.
> 
> Or maybe I misread the regulator_of_get_init_data() function?

The regulator_of_get_init_data() searches from dev->of_node or its child
node.

But dev->of_node is NULL.

That's why of_compatible is needed.

Best regards,
Krzysztof


