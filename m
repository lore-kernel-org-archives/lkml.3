Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaA2Hff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:35:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:31019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaA2Hfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:35:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,740,1384329600"; 
   d="scan'208";a="472478830"
Message-ID: <52E8AF40.6000103@intel.com>
Date: Wed, 29 Jan 2014 15:35:28 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: Re: [PATCH] i2c-designware-pcidrv: fix the incorrect return of idle
 callback
References: <52E744AC.2050606@intel.com> <20140128183035.GC20789@katana> <52E86175.6010300@intel.com>
In-Reply-To: <52E86175.6010300@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2014年01月29日 10:03, xinhui.pan 写道:
> 
>> On Tue, Jan 28, 2014 at 01:48:28PM +0800, xinhui.pan wrote:
>>> From: "xinhui.pan" <xinhuix.pan@intel.com>
>>>
>>> i2c_dw_pci_runtime_idle should return -EBUSY rather than zero if it do success.
>>
>> I don't understand...
>>
> Sorry for my poor English. 
> Even if i2c_dw_pci_runtime_idle succeed ,it should return -EBUSY.
>>> Otherwise rpm_idle will call pm_suspend again and that may cause pm_schedule_suspend delay invalidate.
>>> 	
>>> Signed-off-by: bo.he <bo.he@intel.com>
>>> Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
>>> ---
>>>  drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
>>> index f6ed06c..96e81f6 100644
>>> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
>>> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
>>> @@ -190,8 +190,8 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
>>>  	int err = pm_schedule_suspend(dev, 500);
>>>  	dev_dbg(dev, "runtime_idle called\n");
>>>  
>>> -	if (err != 0)
>>> -		return 0;
>>> +	if (err)
>>> +		return err;
>>>  	return -EBUSY;
>>
>> ... it does return EBUSY when pm_schedule_suspend() succeeds? It only
>> returns 0 if it does not succeed (for which I don't know if this is an
>> apropriate behaviour). Mika?
>>
hi ,
I found one sentence in /Documentation/power/runtime_pm.txt
 "If there is no idle callback, or if the callback returns 0, 
then the PM core will attempt to carry out a runtime suspend of the device,
also respecting devices configured for autosuspend." 
  so is this a right way to prevent this?
Br. xinhui
>>>  }
>>>  
>>> -- 
>>> 1.7.9.5
