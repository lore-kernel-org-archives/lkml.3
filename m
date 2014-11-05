Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKEHAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:00:45 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:64821 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaKEHAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:00:42 -0500
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="49760349"
Message-ID: <5459CB17.3020303@broadcom.com>
Date: Tue, 4 Nov 2014 23:00:39 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Peter Griffin" <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, "Piotr Krol" <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv2 4/5] mmc: shdci-bcm2835: add verify for 32-bit back-to-back
 workaround
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-5-git-send-email-sbranden@broadcom.com> <5459AECF.8000402@wwwdotorg.org>
In-Reply-To: <5459AECF.8000402@wwwdotorg.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-04 08:59 PM, Stephen Warren wrote:
> On 10/30/2014 12:36 AM, Scott Branden wrote:
>> Add a verify option to driver to print out an error message if a
>> potential back to back write could cause a clock domain issue.
>
>> index f8c450a..11af27f 100644
>
>> +#ifdef CONFIG_MMC_SDHCI_BCM2835_VERIFY_WORKAROUND
>> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> +	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
>> +
>> +	if (bcm2835_host->previous_reg == reg) {
>> +		if ((reg != SDHCI_HOST_CONTROL)
>> +			&& (reg != SDHCI_CLOCK_CONTROL)) {
>
> The comment in patch 3 says the problem doesn't apply to the data
> register. Why does this check for these two registers rather than data?
This Verify workaround patch still a work in progress.  I'm still 
getting more info from the silicon designers on the back-to-back 
register writes that are affect.  The spew of 0x20 or 0x28 or 0x2c 
register writes are all ok locations that don't need to be worked 
around.  This patch needs to be corrected with the proper register rules 
still.
>
>> +			dev_err(mmc_dev(host->mmc),
>> +			"back-to-back write to 0x%x\n", reg);
>
> The continuation line should be indented at least one more level here.
>


