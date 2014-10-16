Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaJPQAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:00:38 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:35496 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaJPQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:00:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,733,1406617200"; 
   d="scan'208";a="48602699"
Message-ID: <543FEB82.8000503@broadcom.com>
Date: Thu, 16 Oct 2014 09:00:02 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>, Scott Branden <sbranden@broadcom.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Consider moving the init of pl330 to earlier?
References: <5436FF8F.8060602@broadcom.com> <20141016065912.GB1638@intel.com>
In-Reply-To: <20141016065912.GB1638@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/2014 11:59 PM, Vinod Koul wrote:
> On Thu, Oct 09, 2014 at 02:35:11PM -0700, Ray Jui wrote:
>> Hi,
>>
>> How do you guys like the idea of moving the driver initialization of
>> the pl330 DMA driver to earlier? For example, to arch_initcall_sync
>> or subsys_initcall? Currently the pl330 driver is registered through
>> module_amba_driver call, which translates to device_initcall in the
>> end. This is a bit late considering in many systems, DMA controller
>> is one of the core components that may have many slave devices
>> depending on. Most slave drivers are typically done at
>> device_initcall. When done at the same level, DMA may not be ready
>> while the slave devices are being initialized. In addition, under
>> the drivers/dma directory, we currently have various other DMA
>> drivers also done at subsys_initcall.
>>
>> One issue that I'm seeing with the Broadcom Cygnus SoC is that, when
>> we try to use DMA with SPI (PL022), the request for DMA channel
>> would fail because the spi-pl022 driver we use is initialized at
>> subsys_initcall. At the time the PL330 driver is not yet
>> initialized. The reason why spi-pl022 is done at subsys_initcall is
>> that some regulators communicate through the SPI bus so people
>> decided to move it to earlier (commit 25c8e03b by Linus Walleij),
>> which seems to be a valid reason to me.
> As a subsytem we encourage folks to use early init calls and then have
> clients use late_init so that dependency is solved.
>
> So feel free to send the patch
>
Will do. Thanks!

Ray
