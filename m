Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3FDJCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:02:23 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40702 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FDJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:02:20 -0400
Message-ID: <51ADAD0E.4010001@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:32:06 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Subject: Re: [PATCH v3 8/8] powerpc/pseries: Read common partition via pstore
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420> <20130425101908.21017.32553.stgit@aruna-ThinkPad-T420> <1370062367.3766.30.camel@pasglop>
In-Reply-To: <1370062367.3766.30.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060408-2674-0000-0000-0000093A2E62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 June 2013 10:22 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-04-25 at 15:49 +0530, Aruna Balakrishnaiah wrote:
>
>> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
>> index 8d4fb65..88cc050 100644
>> --- a/fs/pstore/inode.c
>> +++ b/fs/pstore/inode.c
>> @@ -330,6 +330,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>>   	case PSTORE_TYPE_PPC_OF:
>>   		sprintf(name, "of-%s-%lld", psname, id);
>>   		break;
> Call this powerpc-ofw-... Does it even contain something we use in Linux
> at all ? Last I looked we only used the common one right ? Also it's
> format afaik is defined in the CHRP bindings so it's not generic OFW
> stuff, hence the powerpc prefix.
>
>> +	case PSTORE_TYPE_PPC_COMMON:
>> +		sprintf(name, "common-%s-%lld", psname, id);
>> +		break;
> Same deal, call that powerpc-common

Sure. Will change it to powerpc prefix.

>>   	case PSTORE_TYPE_UNKNOWN:
>>   		sprintf(name, "unknown-%s-%lld", psname, id);
>>   		break;
>> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
>> index 615dc18..656699f 100644
>> --- a/include/linux/pstore.h
>> +++ b/include/linux/pstore.h
>> @@ -38,6 +38,7 @@ enum pstore_type_id {
>>   	/* PPC64 partition types */
>>   	PSTORE_TYPE_PPC_RTAS	= 4,
>>   	PSTORE_TYPE_PPC_OF	= 5,
>> +	PSTORE_TYPE_PPC_COMMON	= 6,
>>   	PSTORE_TYPE_UNKNOWN	= 255
>>   };
> Do we expose anything else or keep it hidden ?

We are exposing oops, rtas, of-config and common partition of nvram.

> Cheers,
> Ben.
>
>

