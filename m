Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaJMPnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:43:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39242 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaJMPnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <20141013095310.GZ14343@console-pimps.org>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
	<20141013095310.GZ14343@console-pimps.org>
Date: Mon, 13 Oct 2014 18:43:16 +0300
Message-ID: <CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
From: Sam Protsenko <semen.protsenko@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I originally wrote this patch in 2013 arm64 support didn't exist,
> and ia64 isn't going to be using capsule support. I can separate that
> out into a separate patch though, no problem.

For me it's just the matter of good VCS practices. In this case I call
this "patch atomicity" (one patch per feature). It's not about your
patch particularly, it's just policy. In the end it boils down to next
two things:
 1. Separating common code from platform code makes it easier to use
"git bisect" in case of regressions.
 2. This way if we want to revert patch, we can revert only stuff we
want, not touching another part (e.g. you want to revert platform
code, you can keep common code in place).

> Next time, could you please quote the part of the patch you're
> commenting on inline? That would have saved me searching through the
> original email.

Sure, my bad. I know it's general approach in mailing lists to review
patch, just forgot it.


On 13 October 2014 12:53, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 10 Oct, at 06:55:49PM, Sam Protsenko wrote:
>> Hi Matt,
>>
>> 1. Why x86 code isn't separated to another patch?
>
> When I originally wrote this patch in 2013 arm64 support didn't exist,
> and ia64 isn't going to be using capsule support. I can separate that
> out into a separate patch though, no problem.
>
>> 2. drivers/firmware/efi/reboot.c: efi_reboot():
>>     One shouldn't use "printk()" with no KERN_* stuff passed into it.
>> I'd recommend to use "pr_info()" macro or something like that.
>
> Oops, I missed that, good catch.
>
> Next time, could you please quote the part of the patch you're
> commenting on inline? That would have saved me searching through the
> original email.
>
> --
> Matt Fleming, Intel Open Source Technology Center
