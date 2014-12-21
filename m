Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaLUMqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:46:40 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58454 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaLUMqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <1419134735.27324.41.camel@neuling.org>
References: <1419092024-6701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1419134735.27324.41.camel@neuling.org>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 13:46:16 +0100
Message-ID: <CAFo99ga9TYf5hnwOcoRPKsTHhhknoz6_axzP7spe0mvd=YPMLw@mail.gmail.com>
Subject: Re: [PATCH] misc: cxl: sysfs.c: Remove unused function
To: Michael Neuling <mikey@neuling.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-21 5:05 GMT+01:00 Michael Neuling <mikey@neuling.org>:
>> Remove the function mmio_size_show() that is not used anywhere.
>
> Did you compile check this patch?
>
>   drivers/misc/cxl/sysfs.c:291:74: error: ‘mmio_size_show’ undeclared here (not in a function)
>
> It's used here:
>         static struct device_attribute afu_attrs[] = {
>                 __ATTR_RO(mmio_size),
>
>> This was partially found by using a static code analysis program called cppcheck.
>
> Thanks for letting me know which tool to avoid :-)
>
> Mikey
>
>
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/misc/cxl/sysfs.c |   11 -----------
>>  1 file changed, 11 deletions(-)
>>
>> diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
>> index ce7ec06..0431ec3 100644
>> --- a/drivers/misc/cxl/sysfs.c
>> +++ b/drivers/misc/cxl/sysfs.c
>> @@ -102,17 +102,6 @@ static struct device_attribute afu_master_attrs[] = {
>>
>>  /*********  AFU attributes  **************************************************/
>>
>> -static ssize_t mmio_size_show(struct device *device,
>> -                           struct device_attribute *attr,
>> -                           char *buf)
>> -{
>> -     struct cxl_afu *afu = to_cxl_afu(device);
>> -
>> -     if (afu->pp_size)
>> -             return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_size);
>> -     return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->adapter->ps_size);
>> -}
>> -
>>  static ssize_t reset_store_afu(struct device *device,
>>                              struct device_attribute *attr,
>>                              const char *buf, size_t count)
>


Hi

Sorry about that.

Strange because I compile everything as allyesconfig, allmodconfig and
allnoconfig.

Kind regards
Rickard Strandqvist
