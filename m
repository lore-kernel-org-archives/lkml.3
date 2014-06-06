Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaFFNCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:02:32 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49680 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaFFNCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:02:31 -0400
MIME-Version: 1.0
In-Reply-To: <1401920905.17510.42.camel@dabdike>
References: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1401920905.17510.42.camel@dabdike>
Date: Fri, 6 Jun 2014 15:02:30 +0200
Message-ID: <CAFo99gaMCx5i528MNeOk5DZ93G8m=XdmDQfH2K8LAQQXt-MpyQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I did not know that Linux had strlcpy, much better choice, of course!

It was not clear that this was done in the code. And my thought was,
rather, just that you were not sure if there was a null character
because it used strlcpy. if this can not possibly happen would be
almost as well to switch to strcpy outright.

So what happens now?
Should I make a new patch, with strlcpy or just straight off with strcpy then?



Best regards
Rickard Strandqvist


2014-06-05 0:28 GMT+02:00 James Bottomley
<James.Bottomley@hansenpartnership.com>:
> On Wed, 2014-06-04 at 23:36 +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> This was partly found using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> index bde63f7..4c3eceb 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>> @@ -2097,7 +2097,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>>       u32 bios_version;
>>
>>       bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
>> -     strncpy(desc, ioc->manu_pg0.ChipName, 16);
>> +     strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
>> +     desc[sizeof(desc) - 1] = '\0';
>
> There's no bug here because the specs define the ChipName field of the
> manufacturing page 0 to be 16 bytes and null terminated.  The nasty part
> is the way this driver is littered with magic numbers.
>
> James
>
>
