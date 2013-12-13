Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3LMCBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:01:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60566 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3LMCBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:01:07 -0500
Message-ID: <52AA6A60.7050308@ti.com>
Date: Thu, 12 Dec 2013 21:01:04 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: host: xhci: Move suspend ops under PM_SLEEP to avoid
 warning
References: <1386896784-23916-1-git-send-email-santosh.shilimkar@ti.com> <20131213015133.GA29964@psi-dev26.jf.intel.com>
In-Reply-To: <20131213015133.GA29964@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 08:51 PM, David Cohen wrote:
> On Thu, Dec 12, 2013 at 08:06:24PM -0500, Santosh Shilimkar wrote:
>> Otherwise you get below build warnings
>>
>> drivers/usb/host/xhci-plat.c:201:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
>> drivers/usb/host/xhci-plat.c:209:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]
>>
>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  drivers/usb/host/xhci-plat.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index d9c169f..4875be5 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -197,7 +197,7 @@ static int xhci_plat_remove(struct platform_device *dev)
>>  	return 0;
>>  }
>>  
>> -#ifdef CONFIG_PM
>> +#ifdef CONFIG_PM_SLEEP
> 
> Can't you just remove these #ifdefs altogether?
> xhci_plat_pm_ops is set using SET_SYSTEM_SLEEP_PM_OPS() macro which
> already handles '#ifdef CONFIG_PM_SLEEP' case.
> 
It does handle the difference but the hooks implemented would
show-up un-used warning if you remove the #ifdefs.

drivers/usb/host/xhci-plat.c:200:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
drivers/usb/host/xhci-plat.c:208:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]

So you need to wrap them under the PM_SLEEP check.

Regards,
Santosh

