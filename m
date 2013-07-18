Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab3GRXol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:44:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934601Ab3GRXok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:44:40 -0400
Message-ID: <51E87DD4.3000907@zytor.com>
Date: Thu, 18 Jul 2013 16:44:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Tim Chen <tim.c.chen@linux.intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak <ak@linux.intel.com>,
        rjw@rjwysocki.net
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>  <1374098936.22432.322.camel@schen9-DESK>  <201307180347.r6I3l5e9077577@www262.sakura.ne.jp> <1374181200.22432.350.camel@schen9-DESK> <51E8696A.7090406@intel.com>
In-Reply-To: <51E8696A.7090406@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 03:17 PM, Rafael J. Wysocki wrote:
>>
>> alias x86cpu:vendor:*:family:*:model:*:feature:*0081* crct10dif_pclmul
>>
>> This should cause udev to load the crct10dif_pclml module when cpu
>> support the PCLMULQDQ (feature code 0081).  I did my testing during
>> development on 3.10 and the module was indeed loaded.
>>
>> However, I found that the following commit under 3.11-rc1 broke
>> the mechanism after some bisection.
>>
>> commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Date:   Fri May 3 00:26:22 2013 +0200
>>
>>      ACPI / processor: Use common hotplug infrastructure
>>           Split the ACPI processor driver into two parts, one that is
>>      non-modular, resides in the ACPI core and handles the enumeration
>>      and hotplug of processors and one that implements the rest of the
>>      existing processor driver functionality.
>>      Rafael, can you check and see if this can be fixed so those
>> optimized
>> crypto modules for Intel cpu that support them can be loaded?
> 
> I think this is an ordering issue between udev startup and the time when
> devices are registered.
> 
> I wonder what happens if you put those modules into the initramfs image?
> 

OK, this bothers me on some pretty deep level... a set of changes
exclusively in drivers/acpi breaking functionality which had nothing to
do with ACPI, specifically CPU-feature-based module loading.

Please let me know what the investigation comes up with, or if I need to
get more directly involved.

	-hpa

