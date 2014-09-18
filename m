Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaIRFBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:01:38 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:48187 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaIRFBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:01:36 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1410991612.4290.10.camel@joe-AO725>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com> <1410990447-3210-2-git-send-email-fransklaver@gmail.com> <1410991612.4290.10.camel@joe-AO725>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/9] eeepc-laptop: clean up coding style
From: Frans Klaver <fransklaver@gmail.com>
Date: Thu, 18 Sep 2014 07:01:25 +0200
To: Joe Perches <joe@perches.com>
CC: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <642509cf-05f2-47f4-be2e-a3cfb9a93a04@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 September 2014 00:06:52 CEST, Joe Perches <joe@perches.com> wrote:
>On Wed, 2014-09-17 at 23:47 +0200, Frans Klaver wrote:
>> Correct indentation and brace usage to comply with
>> Documentation/CodingStyle.
>> 
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/platform/x86/eeepc-laptop.c
>b/drivers/platform/x86/eeepc-laptop.c
>> index 3095d38..653999e 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -544,7 +544,7 @@ static int eeepc_led_init(struct eeepc_laptop
>*eeepc)
>>  	eeepc->tpd_led.name = "eeepc::touchpad";
>>  	eeepc->tpd_led.brightness_set = tpd_led_set;
>>  	if (get_acpi(eeepc, CM_ASL_TPD) >= 0) /* if method is available */
>> -	  eeepc->tpd_led.brightness_get = tpd_led_get;
>> +		eeepc->tpd_led.brightness_get = tpd_led_get;
>>  	eeepc->tpd_led.max_brightness = 1;
>>  
>>  	rv = led_classdev_register(&eeepc->platform_device->dev,
>> @@ -692,8 +692,9 @@ static int eeepc_register_rfkill_notifier(struct
>eeepc_laptop *eeepc,
>>  		 * changed during setup.
>>  		 */
>>  		eeepc_rfkill_hotplug(eeepc, handle);
>> -	} else
>> +	} else {
>>  		return -ENODEV;
>> +	}
>>  
>>  	return 0;
>>  }
>
>This sort of code:
>
>	if (foo) {
>		[ do_something ]
>	} else
>		return -ERRVAL;
>
>is generally better rewritten as:
>
>	if (!foo)
>		return -ERRVAL;
>
>	[ do_something ]
>
>This gives immediacy to the error handler and
>as well reduces unnecessary indentation.

I fully agree. 

Darren, do you still take this in one patch? 

Frans

