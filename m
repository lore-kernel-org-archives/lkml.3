Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaEPNiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:63661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbaEPNh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1067,1389772800"; 
   d="scan'208";a="512771709"
Message-ID: <537614A0.1050908@linux.intel.com>
Date: Fri, 16 May 2014 21:37:36 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>,
        Jin Yao <yao.jin@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] ACPI / LPSS: Solution for two issues seen on Asus
 T100
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>	 <5374D0A8.2090407@linux.intel.com>	 <1400165610.3703.41.camel@smile.fi.intel.com>	 <5374E472.9030001@linux.intel.com>	 <20140515161148.GM1674@lahna.fi.intel.com> <53754DF4.10302@linux.intel.com> <1400223856.3703.44.camel@smile.fi.intel.com>
In-Reply-To: <1400223856.3703.44.camel@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/16 15:04, Andy Shevchenko wrote:
> On Fri, 2014-05-16 at 07:29 +0800, Li, Aubrey wrote:
>> On 2014/5/16 0:11, Mika Westerberg wrote:
>>> On Thu, May 15, 2014 at 11:59:46PM +0800, Li, Aubrey wrote:
>>>> On 2014/5/15 22:53, Andy Shevchenko wrote:
>>>>> On Thu, 2014-05-15 at 22:35 +0800, Li, Aubrey wrote:
>>>>>> On 2014/5/15 21:40, Heikki Krogerus wrote:
>>>>>>> Changes since v1:
>>>>>>> - now using do_div() in clk_fd_recalc_rate() as suggested by Andy
>>>>>>> - NULL checks for clk_name allocation in acpi_lpss.c
>>>>>>>
>>>>>>> This combines two patch sets for LPSS that I had already send for
>>>>>>> review separately. They conflicted with each other.
>>>>>>>
>>>>>>> The first two patches will fix a problem were the context of the
>>>>>>> private LPSS registers is lost when entering D3. The last two will add
>>>>>>> support for the M/N dividers on LPSS by adding a new basic clock type
>>>>>>> for fractional dividers. The UART driver needs support for it in order
>>>>>>> to get clock rates that suit the requested baud rates.
>>>>>>
>>>>>> The major issue in my mind is, this proposal makes a couple between I2C
>>>>>> designware, HSUART, or probably DMA driver as well with LPSS driver.
>>>>>
>>>>> acpi_lpss driver creates platform devices for each found and enumerated
>>>>> device.
>>>>
>>>>> If there no acpi_lpss enabled the drivers work as supposed without it.
>>>>
>>>> This is not true.
>>>
>>> The drivers work fine on non-LPSS platform. If you make them depend on
>>> acpi_lpss, you break that.
>>>
>>
>> People don't know the relationship between LPSS driver and I2C/HSUART,
>> there is nowhere to describe that. If LPSS driver is unchecked, they
>> will encounter a weird issue which is very hard to figure out what's
>> going on.
> 
> Besides this discussion is off the topic, I could say that LPSS drivers
> are kinda optional (we won't enforce user to use them) even on some
> systems where they are present. Relationship is provided by the proper
> kernel configuration.
> 
It is optional previously but definitely not optional after this patch.
The user who uses I2C designeware driver without LPSS now, I2C won't
work properly on Asus T100.

The proper configuration leads to a question, why a completed I2C
controller driver doesn't work properly without another LPSS driver. I
worry about this is hard to maintain in future.

Do we have a platform configuration to specify LPSS is needed?

BTW, do we have a system with I2C and HSUART but without LPSS?

Thanks,
-Aubrey

Thanks,
-Aubrey



