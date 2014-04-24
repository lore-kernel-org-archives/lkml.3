Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaDXJMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:12:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55403 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbaDXJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:12:40 -0400
Message-ID: <5358D584.6080206@ti.com>
Date: Thu, 24 Apr 2014 12:12:36 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sameo@linux.intel.com>, <nm@ti.com>
Subject: Re: [RESEND 0/3] mfd: twl6040: Updates for i2s speed and fix for
 chip deadlock
References: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On 04/01/2014 04:44 PM, Peter Ujfalusi wrote:
> Hi,
> 
> While looking into a report by Florian Vaussard [1] I have noticed couple of most
> likely unrelated issues:
> - all boards using twl6040 configures the i2c bus to 400KHz while twl6040 is set
>   to 100KHz as default.
> - if I set the audpwron GPIO high [2] in the bootloader the i2c communication towards
>   twl6040 will be broken
> - got confirmation from HW design teams that twl6040 can work on a bus with
>   400KHz even if after hard reset but it is optimal to swithc to 400KHz mode as
>   soon as possible.
> 
> The solution or these are:
> set the twl6040 to i2c fast mode with regmap patch
> Clear the INTID register right after we request the audpwron GPIO and set it to
> low.

Do you want me to resend this series again?

Thanks,
Péter

> 
> Generated on top of:
> git://git.linaro.org/people/lee.jones/mfd.git for-mfd-next
> 
> Tested on PandaBoard, PandaBoardES, OMAP4-blaze (SDP)
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg310725.html
> [2] Command in u-boot to enable the audpwron on PandaBoards: gpio set 127
> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (3):
>   mfd: twl6040: Select i2c fast mode as default with regmap patch
>   mfd: twl6040: Move register patching earlier in probe
>   mfd: twl6040: Clear the interrupt ID register before requesting IRQ
> 
>  drivers/mfd/twl6040.c       | 19 +++++++++++++------
>  include/linux/mfd/twl6040.h |  1 +
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 

