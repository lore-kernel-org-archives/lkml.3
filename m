Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3J2S0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:26:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:30063 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab3J2S03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="426622815"
Message-ID: <526FFED4.4070902@linux.intel.com>
Date: Tue, 29 Oct 2013 11:30:44 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com> <1383070766.12439.13.camel@joe-AO722>
In-Reply-To: <1383070766.12439.13.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 10/29/2013 11:19 AM, Joe Perches wrote:
> On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
>> This patch adds driver for ssp spi interface on Intel Mid platform.
>
> A few simple notes:
>
> Please consider using checkpatch.

I did and got no warnings. But haven't used --strict option.

>
>> ---
>>   drivers/spi/Kconfig                   |   12 +
>>   drivers/spi/Makefile                  |    1 +
>>   drivers/spi/spi-intel-mid-ssp.c       | 1506 +++++++++++++++++++++++++++++++++
>>   include/linux/spi/intel_mid_ssp_spi.h |  330 ++++++++
>
> Shouldn't this include file be in the drivers/spi directory?

I can't be. This header file will be needed by Intel MID platform code
located under arch/x86/platform/intel-mid/ directory.

>
> []
>
>> diff --git a/drivers/spi/spi-intel-mid-ssp.c b/drivers/spi/spi-intel-mid-ssp.c
> []
>> +#ifdef DUMP_RX
>> +static void dump_trailer(const struct device *dev, char *buf, int len, int sz)
>> +{
>
> You could save a couple of later #ifdefs by
> moving the #ifdef inside the function

I can do that.

>
> static void dump_trailer(etc)
> {
> #ifdef DUMP_RX
> 	...
> #endif
> }
>
>> +static int map_dma_buffers(struct ssp_drv_context *sspc)
>> +{
> []
>> +#ifdef DUMP_RX
>> +		dump_trailer(&sspc->pdev->dev, sspc->tx, sspc->len, 16);
>> +#endif
>
>> +static void int_transfer_complete(struct ssp_drv_context *sspc)
>> +{
> []
>> +#ifdef DUMP_RX
>> +	dump_trailer(dev, sspc->rx, sspc->len, 16);
>> +#endif
>
>> +static int setup(struct spi_device *spi)
>> +{
> []
>> +	if (!chip) {
>> +		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
>> +		if (!chip) {
>> +			dev_err(&spi->dev,
>> +			"failed setup: can't allocate chip data\n");
>
> OOM messages aren't necessary as a generic OOM message
> is already emitted along with a dump_stack();

So I'll remove the message.

Thanks for your feedback. A new version is coming soon.

Br, David Cohen

