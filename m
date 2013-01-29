Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3A2Brk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:47:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7577 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A2Brh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:47:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="22922164"
Message-ID: <51072A38.6090505@codeaurora.org>
Date: Mon, 28 Jan 2013 17:47:36 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com> <5106D3CA.4030203@codeaurora.org> <20130129013858.GA4748@opensource.wolfsonmicro.com>
In-Reply-To: <20130129013858.GA4748@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/13 17:39, Mark Brown wrote:
> On Mon, Jan 28, 2013 at 11:38:50AM -0800, Stephen Boyd wrote:
>> On 01/27/13 06:12, Mark Brown wrote:
>>> +static int regmap_spi_async_write(void *context,
>>> +				  const void *reg, size_t reg_len,
>>> +				  const void *val, size_t val_len,
>>> +				  struct regmap_async *a)
>>> +{
>>> +	struct regmap_async_spi *async = (void *)a;
>> Can you use container_of() here?
> We could but I tend not to if the interface strictly requires that the
> pointers be type punnable.

What is the interface requiring strict type punning here? async_write?

I just hope we don't move the fields around in the regmap_async_spi
struct and then this code silently breaks. I hope the compiler is smart
enough to skip doing any math if we used container_of() with the current
struct layout.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

