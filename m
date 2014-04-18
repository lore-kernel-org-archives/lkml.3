Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaDRV2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:28:23 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63797 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaDRV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140418201313.GG5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
	<20140418124821.GE5904@bivouac.eciton.net>
	<CAL_JsqKdFyhHfkcC1E9QuKjQTrXwoELYG+CFTpgf2-jqDvxGmA@mail.gmail.com>
	<20140418201313.GG5904@bivouac.eciton.net>
Date: Fri, 18 Apr 2014 16:28:17 -0500
Message-ID: <CAL_Jsq+L14rgYq5swC3H109DThiyDajmTJpO=y562jcE97K-fg@mail.gmail.com>
Subject: Re: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
From: Rob Herring <robherring2@gmail.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 3:13 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Fri, Apr 18, 2014 at 10:37:58AM -0500, Rob Herring wrote:
>> >> But why do you need this?
>> >
>> > Apart from the current code permitting recreating a 15+ year old
>> > firmware bug into completely new platform ports?
>>
>> I would prefer to see a "WARN_ON(!IS_ENABLED(CONFIG_PPC32));" added here.
>
> In addition to, or instead of, the QUIRK ifdef?

Instead of because I don't see how you handle the ARM board
compatibility with the ifdef. (And please, no ifdef for that board).

>> Really, I would like to see quirks like this fixed up out of line from
>> the normal flow somewhat like how PCI quirks are handled. So in this
>> example, we would just add the missing property to the dtb for the
>> broken platform before doing the memory scan. That does then require
>> libfdt which is something I'm working on.
>
> Getting rid of all this handling from generic code would clearly be
> preferable. Is that code going in in the near future, or could we add
> the quirk as a stopgap?

Some sort of quirk infrastructure is not going to happen soon. It's
just an idea bouncing in my head ATM.

>> > Because the UEFI stub for arm/arm64 needs to delete all of the "memory"
>> > nodes from the DT. And it would be nice to at least not have to compile
>> > the "and also delete anything called memory@0" into the arm64 image. Or
>> > any image not including support for affected platforms.
>>
>> I don't see why you would handle that in the EFI stub. Given our lack
>> of validation, I can see there is a chance this happens but I think it
>> is pretty small. Given we only have a ARM board, I'd say we are doing
>> surprisingly well.
>
> I'm not too bothered personally, but Mark Rutland handed me a patch to
> improve the memory node handling in the stub, and he seemed to really
> want this there. You guys can fight it out :)

Simply put, we shouldn't put work-arounds in new code for new platforms.

> What would be the effect of the UEFI code adding all its memblocks,
> minus the reserved areas, and then the DT code doing a memblock_add
> of all RAM (including reserved areas)? Would memblock_reserve()s on
> the protected regions suffice to prevent crazy stuff from happening?

So use UEFI to add the memory, but then add reserved areas with DT?
I'm not sure I follow, but even if I did I don't know memblock code
well enough to say what it would do.

Rob
