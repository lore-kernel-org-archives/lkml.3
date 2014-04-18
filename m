Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaDRAnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:43:19 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:39344 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaDRAnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
Date: Thu, 17 Apr 2014 19:43:13 -0500
Message-ID: <CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
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

On Thu, Apr 17, 2014 at 12:41 PM, Leif Lindholm
<leif.lindholm@linaro.org> wrote:
> drivers/of/fdt.c contains a workaround for a missing memory type
> entry on longtrail firmware. Make that quirk PPC32 only, and while
> at it - fix up the .dts files in the tree currently working only
> because of that quirk.

But why do you need this?

>
> Cc: devicetree@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
>
> Leif Lindholm (3):
>   arm: dts: add device_type="memory" for ste-ccu8540
>   mips: dts: add device_type="memory" where missing
>   of: Handle memory@0 node on PPC32 only
>
>  arch/arm/boot/dts/ste-ccu8540.dts     |    1 +
>  arch/mips/lantiq/dts/easy50712.dts    |    1 +
>  arch/mips/ralink/dts/mt7620a_eval.dts |    1 +
>  arch/mips/ralink/dts/rt2880_eval.dts  |    1 +
>  arch/mips/ralink/dts/rt3052_eval.dts  |    1 +
>  arch/mips/ralink/dts/rt3883_eval.dts  |    1 +

I'm not worried about these MIPS dts files because they are all
built-in, but you are breaking compatibility with old dtbs for this
ARM board.

Rob

>  drivers/of/fdt.c                      |    7 ++++++-
>  7 files changed, 12 insertions(+), 1 deletion(-)
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
