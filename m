Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3H2Dng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:43:36 -0400
Received: from server.geeky.co.nz ([103.6.28.146]:58591 "EHLO
	server.geeky.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3H2Dnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:43:35 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 23:43:35 EDT
Message-ID: <521EBD9F.7070502@snapithd.com>
Date: Thu, 29 Aug 2013 15:18:55 +1200
From: Chris Rodley <chris@snapithd.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
CC: kernel@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: sht15 kernel driver
References: <521E7CA7.5060407@snapithd.com> <87fvtt4dmt.fsf@jerows.sfl>
In-Reply-To: <87fvtt4dmt.fsf@jerows.sfl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jerome!

That was just what I needed to know.
The device is now set up and is working well - I will have a go at back 
porting now.

Many thanks again for your help!
Chris

On 29/08/13 11:08, Jerome Oufella wrote:
>> Hi,
>>
>> I am trying to get a sht75 humidity and temperature sensor working
>> with the linux kernel module in 3.2.
>> Is there a code example for application code that you have available?
>>
>> Many thanks,
> Hi Chris,
>
> There was much less support for the sht15 back in 3.2 compared to recent
> kernel releases. You may want to backport features and/or fixes to suit
> your needs.
>
> You can find a usage example for 3.2 in arch/arm/mach-pxa/stargate2.c
> around line 140:
>
> First, create a platform data struct and specify which GPIO lines are
> hooked to the data and sck lines of your sht-15:
>   
>   static struct sht15_platform_data platform_data_sht15 = {
>          .gpio_data =  100,
>          .gpio_sck  =  98,
>   };
>
> Then setup a platform device referencing those platform data, that you
> will have to register on the platform bus using platform_add_devices()
> or equivalent:
>
>   static struct platform_device sht15 = {
>          .name = "sht15",
>          .id = -1,
>          .dev = {
>                  .platform_data = &platform_data_sht15,
>          },
>   };
>
>   ...
>
>   platform_add_devices(...);
>
>
>
> Cheers,

