Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaBSUEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:04:32 -0500
Received: from [176.62.209.28] ([176.62.209.28]:36842 "EHLO
	centos1.newflow.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753731AbaBSUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:04:31 -0500
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 15:04:30 EST
Message-ID: <530509FA.9070800@newflow.co.uk>
Date: Wed, 19 Feb 2014 19:46:02 +0000
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 2/2] misc: add missing minor nodes
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com> <1392701245-4645-3-git-send-email-lucas.demarchi@intel.com> <20140218185228.GC29209@kroah.com>
In-Reply-To: <20140218185228.GC29209@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/14 18:52, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2014 at 02:27:25AM -0300, Lucas De Marchi wrote:
>> From: Lucas De Marchi <lucas.demarchi@intel.com>
>>
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> ---
>>  Documentation/devices.txt | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
>> index 04356f5..0ea1cc2 100644
>> --- a/Documentation/devices.txt
>> +++ b/Documentation/devices.txt
>> @@ -329,6 +329,7 @@ Your cooperation is appreciated.
>>  		filesystem across multiple physical disks.
>>  
>>   10 char	Non-serial mice, misc features
>> +		  0 = /dev/fram
>>  		  0 = /dev/logibm	Logitech bus mouse
>>  		  1 = /dev/psaux	PS/2-style mouse port
>>  		  2 = /dev/inportbm	Microsoft Inport bus mouse
> 
> That's not ok at all, and probably a bug, someone must have thought that
> minor 0 ment "give me a dynamic number."  No one caught this when the
> driver was first merged in a arch-specific tree in 2008 :(
> 
> In looking at the driver, it probably should just be a UIO driver, or
> something else, all it does it map frame buffer memory to userspace,
> given the hardware involved, odds are no one even uses it anymore...
> 
> Mark and Haavard, any thoughts about the
> arch/avr32/boards/mimc200/fram.c driver?  Can I fix up the minor number
> here, or just delete the driver entirely if it's not being used anymore?

I think it's safe to delete the driver.

The mimc200 unit is now basically obsolete and there'll be no new development on it.

Regards
Mark J.
