Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3FQSZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:25:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:48562 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3FQSZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:25:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,882,1363158000"; 
   d="scan'208";a="355029464"
Message-ID: <51BF5611.1080307@linux.intel.com>
Date: Mon, 17 Jun 2013 11:31:45 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH -next v2] thermal:  fix x86_pkg_temp_thermal.c build and
 Kconfig
References: <20130617185106.5950ffbf4b96acd9b2b2c834@canb.auug.org.au> <51BF4159.1000004@infradead.org> <51BF46C3.3090900@linux.intel.com> <51BF4DA2.40601@infradead.org> <51BF50E3.9000806@linux.intel.com> <51BF5174.805@infradead.org> <20130617181702.GA7217@pd.tnic>
In-Reply-To: <20130617181702.GA7217@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 11:17 AM, Borislav Petkov wrote:
> On Mon, Jun 17, 2013 at 11:12:04AM -0700, Randy Dunlap wrote:
>> On 06/17/13 11:09, Srinivas Pandruvada wrote:
>>> Sorry for this issue. I was about to submit a patch for this,
>>>
>>> You should change to
>>>
>>> depends on X86 && X86_MCE && X86_THERMAL_VECTOR
>> ---
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build error in x86_pkg_temp_thermal.c.  It requires that
>> X86_MCE be enabled, so depend on that symbol.
>> Also, X86_PKG_TEMP_THERMAL is already inside an "if THERMAL" block,
>> so remove that duplicated dependency.
>>
>> ERROR: "platform_thermal_package_rate_control" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
>> ERROR: "platform_thermal_package_notify" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>>   drivers/thermal/Kconfig |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> --- linux-next-20130617.orig/drivers/thermal/Kconfig
>> +++ linux-next-20130617/drivers/thermal/Kconfig
>> @@ -171,8 +171,7 @@ config INTEL_POWERCLAMP
>>   
>>   config X86_PKG_TEMP_THERMAL
>>   	tristate "X86 package temperature thermal driver"
>> -	depends on THERMAL
>> -	depends on X86
>> +	depends on X86 && X86_MCE && X86_THERMAL_VECTOR
> X86_THERMAL_VECTOR depends on X86_MCE_INTEL which depends on X86_MCE. So
>
> 	depends on X86_THERMAL_VECTOR
>
> should be enough, IMO.
OK

