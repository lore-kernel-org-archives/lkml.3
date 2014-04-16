Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaDPQgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:36:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51954 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaDPQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:36:16 -0400
Message-ID: <534EB17D.6090307@linaro.org>
Date: Wed, 16 Apr 2014 09:36:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Seunghun Lee <waydi1@gmail.com>
CC: greg@kroah.com, swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] staging : android : uapi : fix coding style
References: <1397658459-4357-1-git-send-email-waydi1@gmail.com> <1397659190.32088.4.camel@joe-AO722>
In-Reply-To: <1397659190.32088.4.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 07:39 AM, Joe Perches wrote:
> On Wed, 2014-04-16 at 23:27 +0900, Seunghun Lee wrote:
>> This patch fix checkpatch.pl warnings and errors.
> []
>> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
> []
>> @@ -169,7 +169,7 @@ struct binder_ptr_cookie {
>>  struct binder_handle_cookie {
>>  	__u32 handle;
>>  	binder_uintptr_t cookie;
>> -} __attribute__((packed));
>> +} __packed;
> If this .h file is meant to be a user-space #include,
> then it should not use the kernel specific __packed
> but keep the __attribute__((packed))

Agreed.

> It does use __u32 though and that's generally
> kernel specific.

Hmm. Theres a ton of __u32 usage in include/uapi/*  as well as typedefs
for it too.
include/uapi/asm-generic/int-l64.h:typedef unsigned int __u32;
include/uapi/asm-generic/int-ll64.h:typedef unsigned int __u32;

> John?  Does any of these binder uapi files need a
> bit more sorting out?
I suspect this is ok, but Cc'ing Colin to give him a heads up, as it
would probably cause trouble w/ their libc headers first.


thanks
-john
