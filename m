Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3A1P2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:28:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:4379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3A1P23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,551,1355126400"; 
   d="scan'208";a="253623648"
Message-ID: <5106991B.1090009@intel.com>
Date: Mon, 28 Jan 2013 23:28:27 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the usb tree
References: <20130128214644.a3906eecaf9123b05216dcaf@canb.auug.org.au> <20130128144508.GA2997@kroah.com>
In-Reply-To: <20130128144508.GA2997@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/28 22:45, Greg KH wrote:
> On Mon, Jan 28, 2013 at 09:46:44PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>>
>> drivers/usb/core/usb-acpi.c: In function 'usb_acpi_register_power_resources':
>> drivers/usb/core/usb-acpi.c:226:2: error: implicit declaration of function 'acpi_power_resource_register_device' [-Werror=implicit-function-declaration]
>> drivers/usb/core/usb-acpi.c: In function 'usb_acpi_unregister_power_resources':
>> drivers/usb/core/usb-acpi.c:234:3: error: implicit declaration of function 'acpi_power_resource_unregister_device' [-Werror=implicit-function-declaration]
>>
>> Caused by commit 88bb965ed711 ("usb: Register usb port's acpi power
>> resources").
>>
>> I have used the usb tree from next-20130125 for today.
>
> Lan, please send me a patch to resolve this issue.
Hi Greg:
	The cause is that these two routines are replaced with two new routines:
acpi_dev_pm_add_dependent() and acpi_dev_pm_remove_dependent() in the linux-next
branch of linux-pm tree. So this error doesn't take place in the usb-next tree.
	One solution I can think of is that bother you to revert the patch and
I will send new patch with new routines after 3.9 merge window. This will not
affect other functions. Does this make sense? Sorry again.

>
> Stephen, sorry for the breakage.
>
> thanks,
>
> greg k-h
>

-- 
Best Regards
Tianyu Lan
linux kernel enabling team
