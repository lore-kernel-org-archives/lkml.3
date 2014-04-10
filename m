Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862AbaDJJ4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:56:40 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49827 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965559AbaDJJ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140410081031.GM28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
 <20140409151747.GH28585@lukather> <CAGb2v67+YNhw2MXSu9DTKSUfXH=v+uD7KEaxyiPezyf9CYtmPw@mail.gmail.com>
 <20140410081031.GM28585@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 10 Apr 2014 17:56:14 +0800
X-Google-Sender-Auth: tQ1uHmm4X3J01AcGZnp_ypQR3X4
Message-ID: <CAGb2v65xhEHS_qETZUWcjeaVQK1V84J4h1LzA7uTrtWS=7P8+Q@mail.gmail.com>
Subject: Re: [PATCH 00/15] ARM: sunxi: add A31 PL pins support
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 4:10 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Thu, Apr 10, 2014 at 12:27:32AM +0800, Chen-Yu Tsai wrote:
>> >> > Let me know if these changes are too intrusive.
>> >>
>> >> I wonder if we should do a separate driver for the new PIO controller.
>> >> Clearly it's a separate IP block, with it's own clock and reset controls.
>> >
>> > It's been merged together in the A23, hence why we did it like that.
>>
>> I'm not sure I understand. The clock gate and reset control are still separate,
>> are they not?
>
> On the A31 the "regular" port controler handles PA to PH banks, while
> the R_PIO handles the PL and PM banks.
>
> On the A23, the regular port controler handles PA to PL banks, and the
> R_PIO and PM bank doesn't exist.

On closer inspection of the user manual and the SDK code,
there is no reset control for R_PIO in the A23, but there is
still a APB0 gate. Also the register space is still at 0x01f02c00,
the address space for R_PIO.

I know the user manual lists the PL pins under the PIO controller,
however the section doesn't list registers for them. It would seem
they are still separate blocks. Also the kernel code never bothers
to enable the R_PIO clock, possibly because it was enabled by U-boot.

> So we're not quite in the same situation. The A31 is troublesome,
> while the A23 (except for the external interrupts), is pretty much
> what we've seen so far with the A10/A20/...
