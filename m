Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLQUmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 15:42:33 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28426 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:42:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,595,1413270000"; 
   d="scan'208";a="53174847"
Message-ID: <5491EAB1.4040903@broadcom.com>
Date: Wed, 17 Dec 2014 12:42:25 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chris Ball <chris@printf.net>
CC: Ulf Hansson <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v2] mmc: sdhci: add quirk for ACMD23 broken
References: <sbranden@broadcom.com>	<1417738572-10441-1-git-send-email-sbranden@broadcom.com> <86oar2qcpg.fsf@void.printf.net>
In-Reply-To: <86oar2qcpg.fsf@void.printf.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

We'll finish off cleaning up our driver that uses this patch for review 
then.

Thanks,
  Scott

On 14-12-17 11:48 AM, Chris Ball wrote:
> Hi Scott, sorry for the delay,
>
> On Fri, Dec 05 2014, Scott Branden wrote:
>> Add quirk to handle broken auto-CMD23.
>> Some controllers do not respond after the first auto-CMD23 is issued.
>>
>> This allows CMD23 to still work (mandatory for the faster UHS-I mode)
>> rather than disabling CMD23 entirely via SDHCI_QUIRK2_HOST_NO_CMD23.
>>
>> Signed-off by: Corneliu Doban <cdoban@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   drivers/mmc/host/sdhci.c  | 3 ++-
>>   include/linux/mmc/sdhci.h | 2 ++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index ada1a3e..b37331f 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -2985,7 +2985,8 @@ int sdhci_add_host(struct sdhci_host *host)
>>   	/* Auto-CMD23 stuff only works in ADMA or PIO. */
>>   	if ((host->version >= SDHCI_SPEC_300) &&
>>   	    ((host->flags & SDHCI_USE_ADMA) ||
>> -	     !(host->flags & SDHCI_USE_SDMA))) {
>> +	     !(host->flags & SDHCI_USE_SDMA)) &&
>> +	     !(host->quirks2 & SDHCI_QUIRK2_ACMD23_BROKEN)) {
>>   		host->flags |= SDHCI_AUTO_CMD23;
>>   		DBG("%s: Auto-CMD23 available\n", mmc_hostname(mmc));
>>   	} else {
>> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
>> index dba793e..d979cf9 100644
>> --- a/include/linux/mmc/sdhci.h
>> +++ b/include/linux/mmc/sdhci.h
>> @@ -100,6 +100,8 @@ struct sdhci_host {
>>   #define SDHCI_QUIRK2_BROKEN_DDR50			(1<<7)
>>   /* Stop command (CMD12) can set Transfer Complete when not using MMC_RSP_BUSY */
>>   #define SDHCI_QUIRK2_STOP_WITH_TC			(1<<8)
>> +/* Controller broken with using ACMD23 */
>> +#define SDHCI_QUIRK2_ACMD23_BROKEN			(1<<9)
>>
>>   	int irq;		/* Device IRQ */
>>   	void __iomem *ioaddr;	/* Mapped address */
>
> This patch doesn't apply the quirk to any chipsets, so the patch
> doesn't actually change any behavior when run on a mainline kernel.
> Do you have a patch to apply the quirk to your chipset too?  We don't
> typically accept patches that "don't do anything" for mainline users,
> so that's why we'd like to see the chipset patch too.
>
> Thanks,
>
> - Chris.
>

