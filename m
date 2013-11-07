Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3KGKF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:05:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3KGKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:05:55 -0500
Message-ID: <527B6637.4000809@oracle.com>
Date: Thu, 07 Nov 2013 18:06:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephan Mueller <stephan.mueller@atsec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Andreas Dilger <aedilger@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "Ted Ts'o" <tytso@mit.edu>,
        jakub@redhat.com, drepper@redhat.com,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy
 depleting
References: <50A46BBD.3060701@oracle.com> <527B1399.8090805@oracle.com> <2161006.F8akiOkWYa@tauon>
In-Reply-To: <2161006.F8akiOkWYa@tauon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your prompt response!

On 11/07/2013 01:13 PM, Stephan Mueller wrote:

> Am Donnerstag, 7. November 2013, 12:14:17 schrieb Jeff Liu:
> 
> Hi Jeff,
> 
>> Hi Stephan,
>>
>> As per your previous comments for this fix, you have promised another
>> approach which is promising to avoid entropy starvation, I got this
>> info from the following thread: [PATCH] avoid entropy starvation due
>> to stack protection
>> https://lkml.org/lkml/2012/12/14/267
> 
> There are several solutions:
> 
> - Ted is trying to prevent a constant reseeding of the nonblocking_pool 
> from the input_pool with a set of patches. I am unsure whether these 
> patches find their way into the kernel. With those patches, we can 
> happily keep get_random_bytes without too much strain on the input_pool 
> entropy -- i.e. drop the conversion to get_random_int.

Yup, that's would be great if we can solve this problem without that.

> 
> - The begin of the email thread contains a patch that adds a new pool 
> which I called the kernel_pool that is just just for kernel internal 
> purposes. With Teds proposed changes to nonblocking_pool, 
> nonblocking_pool would behave almost like my kernel_pool and thus my 
> kernel_pool patch would not be needed.
> 
> - Lastly I am trying to add a new seed source to random.c and kernel 
> crypto API which could also be used as a stand-alone noise source. That 
> proposed noise source would effectively alleviate a lot of entropy 
> problems. The discussion for inclusion is raging at 
> http://lkml.org/lkml/2013/10/11/582. Ted is having concerns and we are 
> in a discussion to address those.

I spent a few hours reading through the thread through some contents are
beyond my understanding.  Looks the proposed approach has already been
widely tested on various platforms, but there still have concerns like
the random numbers which are generated via the jitter "entropy collector"
probably can not be convinced to be more secure.

Thanks for your efforts and I'll keep a close eye on it's progress.

Regards,
-Jeff
