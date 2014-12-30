Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaL3NSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:18:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57235 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3NSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:18:18 -0500
Message-ID: <54A2A5DD.2030502@ti.com>
Date: Tue, 30 Dec 2014 15:17:17 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Mark Brown <broonie@kernel.org>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <arnd@arndb.de>, <khilman@deeprootsystems.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <chris@printf.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: edma: Split up header file to platform_data
 and API file
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com> <20141208124917.GI16827@intel.com>
In-Reply-To: <20141208124917.GI16827@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 02:49 PM, Vinod Koul wrote:
> On Thu, Nov 27, 2014 at 12:41:31PM +0200, Peter Ujfalusi wrote:
>> include/linux/platform_data/ is not a correct place to keep the API
>> definitions for edma, it is meant to be only for the pdata for the device.
>> Clean up this by moving the API to include/linux/edma.h
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  arch/arm/common/edma.c                     |   3 +-
>>  arch/arm/mach-davinci/devices.c            |   1 +
>>  arch/arm/mach-davinci/include/mach/da8xx.h |   1 +
>>  drivers/dma/edma.c                         |   2 +-
>>  include/linux/edma.h                       | 153 +++++++++++++++++++++++++++++
>>  include/linux/platform_data/edma.h         | 148 ++--------------------------
>>  sound/soc/davinci/davinci-pcm.h            |   1 +
>>  7 files changed, 165 insertions(+), 144 deletions(-)
>>  create mode 100644 include/linux/edma.h
> I was hoping that this will have delete for platform_data/edma.h, do we
> still need that and why shouldn't we get rid of this :)

We still need it for the legacy boot of davinci devices. We can boot some
davinci SoC/boards with DT, but not all of them.

-- 
Péter
