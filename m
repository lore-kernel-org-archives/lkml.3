Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbaCFCQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:16:50 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55428 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaCFCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:16:49 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZSdb_xn=swV3owEr0YwCiYVXp-90iyc=9yi-M_P=+L+Q@mail.gmail.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1393257611-18031-2-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdZSdb_xn=swV3owEr0YwCiYVXp-90iyc=9yi-M_P=+L+Q@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 6 Mar 2014 11:16:28 +0900
Message-ID: <CAAVeFuKUESAXqnMpMY02_1Vg+p1FcPBpFp6_APc3=vkQDaktqw@mail.gmail.com>
Subject: Re: [PATCH 1/6] gpiolib: Allow GPIO chips to request their own GPIOs
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 11:49 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Feb 25, 2014 at 12:00 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>
>> Sometimes it is useful to allow GPIO chips themselves to request GPIOs they
>> own through gpiolib API. One usecase is ACPI ASL code that should be able
>> to toggle GPIOs through GPIO operation regions.
>>
>> We can't really use gpio_request() and its counterparts because it will pin
>> the module to the kernel forever (as it calls module_get()). Instead we
>> provide a gpiolib internal functions gpiochip_request/free_own_desc() that
>> work the same as gpio_request() but don't manipulate module refrence count.
>>
>> Since it's the GPIO chip driver who requests the GPIOs in the first place
>> we can be sure that it cannot be unloaded without the driver knowing about
>> that. Furthermore we only limit this functionality to be available only
>> inside gpiolib.
>>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> I fully trust you in doing the ACPI stuff in patches 2-n but on this patch
> in particular I want Alexandre's review tag as well, as he's working
> actively with the descriptor API and I don't want to add too many quirks
> without his consent.
>
> So Alexandre, what do you say about this?

I will wait for v2 to give it a real review, but since the new
functions are not exposed outside of gpiolib and the patch seems to
serve a real purpose I have no objection to it. Especially if Rafael's
suggestions can be applied.
