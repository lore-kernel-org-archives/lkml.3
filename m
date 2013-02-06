Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3BFRJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:09:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3BFRJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:09:01 -0500
Message-ID: <51128DFF.1090904@zytor.com>
Date: Wed, 06 Feb 2013 09:08:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, autofs@vger.kernel.org
Subject: Re: [PATCH] unbreak automounter support on 64-bit kernel with 32-bit
 userspace (v2)
References: <20130204193952.GA5785@p100.box> <1360130286.4186.0.camel@perseus.themaw.net>
In-Reply-To: <1360130286.4186.0.camel@perseus.themaw.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:58 PM, Ian Kent wrote:
>>
>> diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
>> index 77cdba9..bb991df 100644
>> --- a/include/uapi/linux/auto_fs.h
>> +++ b/include/uapi/linux/auto_fs.h
>> @@ -28,25 +28,16 @@
>>   #define AUTOFS_MIN_PROTO_VERSION	AUTOFS_PROTO_VERSION
>>
>>   /*
>> - * Architectures where both 32- and 64-bit binaries can be executed
>> - * on 64-bit kernels need this.  This keeps the structure format
>> - * uniform, and makes sure the wait_queue_token isn't too big to be
>> - * passed back down to the kernel.
>> - *
>> - * This assumes that on these architectures:
>> - * mode     32 bit    64 bit
>> - * -------------------------
>> - * int      32 bit    32 bit
>> - * long     32 bit    64 bit
>> - *
>> - * If so, 32-bit user-space code should be backwards compatible.
>> + * The wait_queue_token (autofs_wqt_t) is part of a structure which is passed
>> + * back to the kernel via ioctl from userspace. On architectures where 32- and
>> + * 64-bit userspace binaries can be executed it's important that the size of
>> + * autofs_wqt_t stays constant between 32- and 64-bit Linux kernels so that we
>> + * do not break the binary ABI interface by changing the structure size.
>>    */
>> -
>> -#if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
>> - || defined(__powerpc__) || defined(__s390__)
>> -typedef unsigned int autofs_wqt_t;
>> -#else
>> +#if defined(__ia64__) || defined(__alpha__) /* pure 64bit architectures */
>>   typedef unsigned long autofs_wqt_t;
>> +#else
>> +typedef unsigned int autofs_wqt_t;
>>   #endif
>>
>>   /* Packet types */
>
> Acked-by: Ian Kent <raven@themaw.net>
>

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

