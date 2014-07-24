Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbaGXMxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:53:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38106 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbaGXMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-6rUxUnF+dRuroDJqy2K2B5F0r7_bm0X-vyiuQ-83W5w@mail.gmail.com>
References: <mvmvbri4k06.fsf@hawking.suse.de>
	<CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
	<mvmr4264i1p.fsf@hawking.suse.de>
	<CAKv+Gu8SbM_Z=ymBFb2D4EWJeo-6dWuKqE2YNOkqJTKLDEJcYA@mail.gmail.com>
	<mvm4my7j5xh.fsf@hawking.suse.de>
	<CAKv+Gu-6rUxUnF+dRuroDJqy2K2B5F0r7_bm0X-vyiuQ-83W5w@mail.gmail.com>
Date: Thu, 24 Jul 2014 14:53:49 +0200
Message-ID: <CAKv+Gu96k7GOVR85EXtro3Lt0jjiJqxyvT9cwJZ1qc6uzq97bw@mail.gmail.com>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2014 14:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 24 July 2014 14:29, Andreas Schwab <schwab@suse.de> wrote:
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
>>
>>> On 30 June 2014 15:56, Andreas Schwab <schwab@suse.de> wrote:
>>>> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
>>>>
>>>>> Out of curiosity, how did you trigger this failure? I have build this
>>>>> code numerous times (and so have others) and I have never seen this
>>>>> failure.
>>>>
>>>> Did you ever start with a clean tree?
>>>>
>>>
>>> Yep, building both in-tree and out-of-tree, no trouble at all.
>>
>> So you probably didn't configure them as modules.
>>
>
> Yes, all the time, in fact. They have now been added as built-ins to
> the defconfig, but I always build as modules, because it is far easier
> when developing.

Also, looking into this a bit more, in my case I do see
arch/arm64/crypto/.aes-glue-ce.o.cmd containing the command line and
the full set of include/config/... rules that are used to track
dependencies on the configuration.

So what strikes me as odd is this:

>   CC [M]  arch/arm64/crypto/aes-glue-ce.o
> ld: cannot find arch/arm64/crypto/aes-glue-ce.o: No such file or directory

so it seems make is perfectly happy to create the aes-glue-ce.o file,
but the subsequent ld that uses it as input cannot find it. Perhaps
the dependencies are screwed up elsewehere?

Are there any other circumstances of interest? How many threads are
you building in parallel? Other steps to reproduce?

-- 
Ard.
