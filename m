Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbbA0SNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:13:10 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55223 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbbA0SNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:13:08 -0500
Message-ID: <54C7D52F.1090207@linaro.org>
Date: Tue, 27 Jan 2015 20:13:03 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        ard.biesheuvel@linaro.org
CC: dmidecode-devel@nongnu.org, leif.lindholm@linaro.org,
        matt.fleming@intel.com
Subject: Re: [Patch v2 0/2] firmware: dmi-sysfs: add SMBIOS entry point area
 raw attribute
References: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org> <20150127162331.70F43C41077@trevor.secretlab.ca>
In-Reply-To: <20150127162331.70F43C41077@trevor.secretlab.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/27/2015 06:23 PM, Grant Likely wrote:
> On Mon, 26 Jan 2015 15:28:36 +0200
> , Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>   wrote:
>> Some utils, like dmidecode and smbios, needs to access SMBIOS entry
>> table area in order to get information like SMBIOS version, size, etc.
>> Currently it's done via /dev/mem. But for situation when /dev/mem
>> usage is disabled, the utils have to use dmi sysfs instead, which
>> doesn't represent SMBIOS entry. So this patch series adds SMBIOS
>> area to dmi sysfs in order to allow utils in question to work
>> correctly with dmi sysfs.
>>
>> v1: https://lkml.org/lkml/2015/1/23/643
> Hi Ivan,
>
> The change looks good to me, but it is an ABI addition, so it needs to
> be documented. You'll need to add a description to:
>
> Documentation/ABI/testing/sysfs-testing/sysfs-firmware-dmi

Ups...
Ok, It'll be in Documentation/ABI/testing/sysfs-firmware-dmi
Thanks!

>
> Second, (minor point), there is no reason to split this up into two
> patches. It is one feature, and would be better as a single patch.
>
> g.

Ok, it'll be one patch, including documentation

>
>> v2..v1:
>>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>> 	- used additional static var to hold SMBIOS raw table size
>> 	- changed format of get_smbios_entry_area symbol
>> 	  returned pointer on const smbios table
>>
>>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
>> 	- adopted to updated get_smbios_entry_area symbol
>>    	- removed redundant array to save smbios table
>>
>> Ivan Khoronzhuk (2):
>>    firmware: dmi_scan: add symbol to get SMBIOS entry area
>>    firmware: dmi-sysfs: add SMBIOS entry point area attribute
>>
>>   drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   drivers/firmware/dmi_scan.c  | 26 ++++++++++++++++++++++++++
>>   include/linux/dmi.h          |  3 +++
>>   3 files changed, 71 insertions(+)
>>
>> -- 
>> 1.9.1
>>

