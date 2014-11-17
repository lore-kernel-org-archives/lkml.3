Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaKQTnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:43:33 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:50175 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaKQTna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+rthh_yfMhmAGvJDpQwnpL6hKJvuZdeDsu4rJuvUQx_irRYZw@mail.gmail.com>
References: <20141114213459.GA3832@www.outflux.net>
	<20141117150926.GA1968@gondor.apana.org.au>
	<CA+rthh_yfMhmAGvJDpQwnpL6hKJvuZdeDsu4rJuvUQx_irRYZw@mail.gmail.com>
Date: Mon, 17 Nov 2014 11:43:30 -0800
X-Google-Sender-Auth: zhPBQucqNn49LtHu9IQLMUDGpJ0
Message-ID: <CAGXu5jK4vu0uJ2R+MjLfjhrMBOqoLcE_3=e-T=ea=u_ZzSatqw@mail.gmail.com>
Subject: Re: [PATCH] crypto: prefix module autoloading with "crypto-"
From: Kees Cook <keescook@chromium.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:38 AM, Mathias Krause <minipli@googlemail.com> wrote:
> On 17 November 2014 16:09, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Fri, Nov 14, 2014 at 01:34:59PM -0800, Kees Cook wrote:
>>> This prefixes all crypto module loading with "crypto-" so we never run
>>> the risk of exposing module auto-loading to userspace via a crypto API,
>>> as demonstrated by Mathias Krause:
>>>
>>> https://lkml.org/lkml/2013/3/4/70
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Sorry but this doesn't build for me:
>>
>>   CC [M]  drivers/crypto/qat/qat_common/adf_ctl_drv.o
>> drivers/crypto/qat/qat_common/adf_ctl_drv.c:490:21: error: expected declaration specifiers or ‘...’ before string constant
>> make[3]: *** [drivers/crypto/qat/qat_common/adf_ctl_drv.o] Error 1
>> make[2]: *** [drivers/crypto/qat/qat_common] Error 2
>> make[1]: *** [drivers/crypto/qat] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>
> Looks like drivers/crypto/qat/qat_common/adf_ctl_drv.c is missing
> '#include <linux/crypto.h>'.

Ah, looks like I missed a few in my config. I'll attempt allmodconfig
and send a v2.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
