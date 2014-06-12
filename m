Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaFLVXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:23:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52704 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFLVXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:23:11 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <539A047B.3010306@codeaurora.org>
Date: Thu, 12 Jun 2014 16:23:06 -0500
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8C69AEA0-877D-4198-BAD4-393695FBC94E@codeaurora.org>
References: <1402600404-19214-1-git-send-email-galak@codeaurora.org> <1402600404-19214-2-git-send-email-galak@codeaurora.org> <539A047B.3010306@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12, 2014, at 2:50 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 06/12/14 12:13, Kumar Gala wrote:
>> +static int qcom_ahci_probe(struct platform_device *pdev)
>> +{
>> +	struct ahci_host_priv *hpriv;
>> +	struct clk *rxoob_clk;
>> +	int rc;
>> +
>> +	hpriv = ahci_platform_get_resources(pdev);
>> +	if (IS_ERR(hpriv))
>> +		return PTR_ERR(hpriv);
>> +
>> +	/* Try and set the rxoob clk to 100Mhz */
>> +	rxoob_clk = of_clk_get_by_name(pdev->dev.of_node, "rxoob");
> 
> Any reason we can't use devm_clk_get() here?

Was trying to avoid the ref cnt of devm_clk_get() as the clk’s are actually handled in ahci_platform_get_resources/ahci_platform_enable_resources

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

