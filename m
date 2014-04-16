Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaDPKJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:09:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60775 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaDPKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:09:48 -0400
Message-ID: <534E56D3.3040907@ti.com>
Date: Wed, 16 Apr 2014 15:39:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
CC: "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][next] phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY
References: <1394709073-1980-1-git-send-email-grygorii.strashko@ti.com> <5321B4B4.9010806@ti.com>
In-Reply-To: <5321B4B4.9010806@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 13 March 2014 07:07 PM, Santosh Shilimkar wrote:
> On Thursday 13 March 2014 07:11 PM, Strashko, Grygorii wrote:
>> This fixes a regression on Keystone 2 platforms caused by patch
>> 57303488cd37da58263e842de134dc65f7c626d5
>> "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
>> optional support of generic phy in DWC3 core.
>>
>> On Keystone 2 platforms the USB is not working now because
>> CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
>> return -ENOSYS always. The log shows:
>>  dwc3 2690000.dwc3: failed to initialize core
>>  dwc3: probe of 2690000.dwc3 failed with error -38
>>
>> Hence, fix it by making NULL a valid phy reference in Generic PHY
>> APIs stubs in the same way as it was done by the patch
>> 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
>> a valid phy reference".
>>
>> CC: Kishon Vijay Abraham I <kishon@ti.com>
>> CC: Felipe Balbi <balbi@ti.com>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
> This fixes the regression seen in Linux next and patch seems
> reasonable to me.
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Felipe, Kishon,
> Can you guys pick this fix if you are ok by it. Thanks
> 
> 
>>  include/linux/phy/phy.h |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
>> index e2f5ca9..5a9b193 100644
>> --- a/include/linux/phy/phy.h
>> +++ b/include/linux/phy/phy.h
>> @@ -204,21 +204,29 @@ static inline void phy_pm_runtime_forbid(struct phy *phy)
>>  
>>  static inline int phy_init(struct phy *phy)
>>  {
>> +	if (!phy)
>> +		return 0;
>>  	return -ENOSYS;
>>  }
>>  
>>  static inline int phy_exit(struct phy *phy)
>>  {
>> +	if (!phy)
>> +		return 0;
>>  	return -ENOSYS;
>>  }
>>  
>>  static inline int phy_power_on(struct phy *phy)
>>  {
>> +	if (!phy)
>> +		return 0;
>>  	return -ENOSYS;
>>  }
>>  
>>  static inline int phy_power_off(struct phy *phy)
>>  {
>> +	if (!phy)
>> +		return 0;
>>  	return -ENOSYS;
>>  }

Can you add these checks for other stubs in phy.h too?

Thanks
Kishon
