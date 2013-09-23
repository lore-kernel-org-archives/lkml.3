Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3IWTM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:12:56 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:63988 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838Ab3IWTMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:12:54 -0400
X-TM-IMSS-Message-ID: <09cda8cf0000dc8d@nsa.gov>
Message-ID: <52408F0C.4020107@tycho.nsa.gov>
Date: Mon, 23 Sep 2013 14:57:16 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [PATCH 03/13] tpm: xen-tpmfront: Fix default durations
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-4-git-send-email-jgunthorpe@obsidianresearch.com> <20130923185158.GA2507@phenom.dumpdata.com>
In-Reply-To: <20130923185158.GA2507@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:51 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 23, 2013 at 12:14:33PM -0600, Jason Gunthorpe wrote:
>> All the default durations were being set to 10 minutes which is
>> way too long for the timeouts. Normal values for the longest
>> duration are around 5 mins, and short duration ar around .5s.
>>
>> Further, these are just the default, tpm_get_timeouts will set
>> them to values from the TPM (or throw an error).
>>
>> Just remove them.
>
> Sounds sensible.
>
> Daniel?

Also sounds good to me. I believe this was just a remnant of the old
xen-tpmfront code that didn't get removed once the timeouts were being
read from the backend.

>>
>> Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> ---
>>   drivers/char/tpm/xen-tpmfront.c | 7 -------
>>   1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
>> index 7a7929b..6f2fe2b 100644
>> --- a/drivers/char/tpm/xen-tpmfront.c
>> +++ b/drivers/char/tpm/xen-tpmfront.c
>> @@ -210,8 +210,6 @@ static struct attribute_group vtpm_attr_grp = {
>>   	.attrs = vtpm_attrs,
>>   };
>>
>> -#define TPM_LONG_TIMEOUT   (10 * 60 * HZ)
>> -
>>   static const struct tpm_vendor_specific tpm_vtpm = {
>>   	.status = vtpm_status,
>>   	.recv = vtpm_recv,
>> @@ -224,11 +222,6 @@ static const struct tpm_vendor_specific tpm_vtpm = {
>>   	.miscdev = {
>>   		.fops = &vtpm_ops,
>>   	},
>> -	.duration = {
>> -		TPM_LONG_TIMEOUT,
>> -		TPM_LONG_TIMEOUT,
>> -		TPM_LONG_TIMEOUT,
>> -	},
>>   };
>>
>>   static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
>> --
>> 1.8.1.2
>>
>
>


-- 
Daniel De Graaf
National Security Agency
