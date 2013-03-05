Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3CEKZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:25:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51058 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3CEKZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:25:51 -0500
Message-ID: <5135C833.8080209@arm.com>
Date: Tue, 05 Mar 2013 10:25:55 +0000
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
References: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com> <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com> <20130305083707.GA7513@kroah.com>
In-Reply-To: <20130305083707.GA7513@kroah.com>
X-OriginalArrivalTime: 05 Mar 2013 10:25:49.0045 (UTC) FILETIME=[CE2BD250:01CE198B]
X-MC-Unique: 113030510254903501
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 08:37, Greg KH wrote:
> On Mon, Feb 25, 2013 at 06:44:36PM +0000, Serban Constantinescu wrote:
>> Android's shared memory subsystem, Ashmem, does not support calls from a
>> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
>> coming from a 32bit userspace in a 64bit kernel.
>>
>> The patch has been successfully tested on ARMv8 AEM(64bit
>> platform model) and Versatile Express A9(32bit platform).
>>
>> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
>> Acked-by: Arve Hjønnevåg <arve@android.com>
>> Acked-by: John Stultz <john.stultz@linaro.org>
>
> This patch breaks the build on my machine:
> drivers/staging/android/ashmem.c: In function ‘compat_ashmem_ioctl’:
> drivers/staging/android/ashmem.c:711:7: error: ‘compat_size_t’ undeclared (first use in this function)
> drivers/staging/android/ashmem.c:711:7: note: each undeclared identifier is reported only once for each function it appears in

When building for x86_64 we need <linux/compat.h>. Sorry I forgot it, 
should build fine now.

>
> so of course, I can't take it :(

Thanks,
Serban

