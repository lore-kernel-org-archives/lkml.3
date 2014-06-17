Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaFQQK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:10:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44798 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaFQQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:10:27 -0400
Message-ID: <53A0686F.4000303@wwwdotorg.org>
Date: Tue, 17 Jun 2014 10:10:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tj@kernel.org, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-9-git-send-email-mperttunen@nvidia.com> <1470404.13mIFv0Hnj@amdc1032>
In-Reply-To: <1470404.13mIFv0Hnj@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 06:14 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday, June 04, 2014 02:32:38 PM Mikko Perttunen wrote:
>> This adds support for the integrated AHCI-compliant Serial ATA
>> controller present on the NVIDIA Tegra124 system-on-chip.

>> +static inline void sata_writel(struct tegra_ahci_priv *tegra, u32 value,
>> +				 unsigned long offset)
>> +{
>> +	writel(value, tegra->sata_regs + offset);
>> +}
>> +
>> +static inline u32 sata_readl(struct tegra_ahci_priv *tegra,
>> +				unsigned long offset)
>> +{
>> +	return readl(tegra->sata_regs + offset);
>> +}
> 
> sata_writel() and sata_read() static inlines don't seem to add any value.
> 
> Can they be removed?

Such functions are quite idiomatic in drivers, and serve to simplify all
the call-sites by removing the need to write out the addition of the
base address everywhere.

>> +static struct platform_driver tegra_ahci_driver = {
>> +	.probe = tegra_ahci_probe,
>> +	.remove = ata_platform_remove_one,
>> +	.driver = {
>> +		.name = "tegra-ahci",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = tegra_ahci_of_match,
>> +	},
> 
> This driver lacks PM suspend/resume support.  I assume that
> the Tegra124 platform also doesn't support suspend/resume yet
> (if so a comment in the driver code about this would be useful),
> otherwise the driver should be fixed.

We do have basic system suspend/resume support. However, I don't think
missing suspend/resume in an individual driver should stop it from being
merged. It can certainly be added later.
