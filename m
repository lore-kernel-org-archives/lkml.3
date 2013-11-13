Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3KMU5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:57:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55581 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3KMU50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:57:26 -0500
Message-ID: <5283E7A9.6090706@zytor.com>
Date: Wed, 13 Nov 2013 12:57:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc4: Disable __compiletime_object_size for GCC 4.6+
References: <1365821348-7177-1-git-send-email-linux@roeck-us.net> <20131113183913.GK4994@outflux.net>
In-Reply-To: <20131113183913.GK4994@outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 10:39 AM, Kees Cook wrote:
> Hi Guenter,
> 
> On Fri, Apr 12, 2013 at 07:49:08PM -0700, Guenter Roeck wrote:
>> __builtin_object_size is known to be broken on gcc 4.6+.
>> See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.
>>
>> This causes unnecssary build warnings and errors such as
>>
>> In function 'copy_from_user', inlined from 'sb16_copy_from_user'
>> 	at sound/oss/sb_audio.c:878:22:
>> arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
>> 	declared with attribute error: copy_from_user() buffer size is not provably correct
>> make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)
>>
>> Disable it where broken.
> 
> Is there an alternative? This means that things like
> DEBUG_STRICT_USER_COPY_CHECKS are being rendered useless. I don't think
> this is _always_ broken, just under certain situations, right?
> 

It would be one thing to block it for, say, gcc 4.6 and 4.7 only, but
without an upper cap I don't think this is at all okay.

	-hpa


