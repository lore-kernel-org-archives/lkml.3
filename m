Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaEHVse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:48:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:53248 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaEHVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <536A4454.5020404@hurleysoftware.com>
References: <536A339D.9030606@hurleysoftware.com>
	<20140507140558.GA26294@ks3318809.kimsufi.com>
	<536A4454.5020404@hurleysoftware.com>
Date: Thu, 8 May 2014 23:48:32 +0200
Message-ID: <CACRpkdZ_Wz2QLbdbXEL9CWy+=tcVwjVjVqQgYw7_dy-5FwxB9Q@mail.gmail.com>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in ichx_gpio_request_regions()
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Vincent Donnefort <vdonnefort@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 4:33 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Hi Vincent,
>
> On 05/07/2014 10:05 AM, Vincent Donnefort wrote:
>>
>> Hello Peter,
>
>
>>> This is almost certainly caused by the uninitialized regs ptr
>>> in the ich6_desc struct (i3100_desc struct has the same problem)
>>> introduced in this commit:
>>>
>>> commit bb62a35bd5d96e506af0ea8dd145480b9172a2a6
>>> Author: Vincent Donnefort <vdonnefort@gmail.com>
>>> Date:   Fri Feb 14 15:01:56 2014 +0100
>>>
>>>      gpio: ich: Add support for multiple register addresses
>>>
>>>      This patch introduces regs and reglen pointers which allow a chipset
>>> to have
>>>      register addresses differing from ICH ones.
>>>
>>>      Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>      Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>>>      Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>
>>
>> Yes indeed, this must be linked to this thread
>> https://lkml.org/lkml/2014/4/15/292
>
>
> Thanks for the link.
>
> I searched through LKML but without the driver name or the offending
> function
> in the commit message I couldn't find it.
>
> Linus,
>
> What tree is this bug fix trapped in? I see it didn't make -rc4 either.

Since the last signoff is Lee I guess it's in the MFD tree?

Yours,
Linus Walleij
