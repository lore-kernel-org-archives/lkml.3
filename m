Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3CEKip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:38:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39575 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CEKio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:38:44 -0500
Message-ID: <5135CB38.1030201@arm.com>
Date: Tue, 05 Mar 2013 10:38:48 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
References: <20130305083707.GA7513@kroah.com> <1362478708-26946-1-git-send-email-serban.constantinescu@arm.com> <20130305102745.GA3327@kroah.com>
In-Reply-To: <20130305102745.GA3327@kroah.com>
X-OriginalArrivalTime: 05 Mar 2013 10:38:41.0839 (UTC) FILETIME=[9ACAD3F0:01CE198D]
X-MC-Unique: 113030510384203501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 10:27, Greg KH wrote:
> On Tue, Mar 05, 2013 at 10:18:27AM +0000, Serban Constantinescu wrote:
>> Android's shared memory subsystem, Ashmem, does not support calls from a
>> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
>> coming from a 32bit userspace in a 64bit kernel.
>>
>> The patch has been successfully tested on ARMv8 AEM(64bit
>> platform model) and Versatile Express A9(32bit platform).
>>
>> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
>> ---
>>   drivers/staging/android/ashmem.c |   22 +++++++++++++++++++++-
>>   drivers/staging/android/ashmem.h |    6 ++++++
>>   2 files changed, 27 insertions(+), 1 deletion(-)
>
> Ok, what has changed from your previous version that I rejected that is
> going to actually allow this to build?

I had to add <linux/compat.h> for a successful build on x86_64. The 
attached hunk is the only change added.

> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> index 72064fc..e96f381 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -31,6 +31,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mutex.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/compat.h>
>  #include "ashmem.h"
>
>  #define ASHMEM_NAME_PREFIX "dev/ashmem/"


>
> Hint, you gotta tell me what version of the patch this is, and what
> changed, otherwise I'll just assume this is a resend of the previous
> patch and go ahead and delete it from my queue.

Sorry - same patch as before, the one that had John and Arve's ack, plus 
the above hunk.
>
> In fact, I might as well do that, now deleted :)
>
> greg k-h
>

Thanks,
Serban

