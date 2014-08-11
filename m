Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaHKRl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:41:29 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36632 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaHKRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
	<20140806095012.GN30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<20140808180900.GG30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
Date: Mon, 11 Aug 2014 14:41:25 -0300
Message-ID: <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:32 AM, Mattis Lorentzon
<Mattis.Lorentzon@autoliv.com> wrote:
> Russell and Fabio,
>
>> I'd be interested to hear whether removing the
>>
>>       interrupts-extended = ...
>>
>> property from your board's DT file, thereby causing you to revert back to the
>> default I list above, also fixes the instability you are seeing.
>
> We have tried to remove the board specific interrupts-extended field and the
> MX6QDL_PAD_GPIO_6__ENET_IRQ entry. Sadly this did not seem to improve
> the stalls. Our interrupts look like this now:
>
> 150:      15519          0          0          0       GIC 150  2188000.ethernet
> 151:          0          0          0          0       GIC 151  2188000.ethernet
>
> Our device tree might still be slightly incorrect. We have noticed that our
> RGMII_INT is connected to GPIO 19 (P5) which might be nonstandard (we are
> a bit surprised that this works at all). We are not quite sure how to configure
> this properly.

In order to try to narrow down whether this is a board issue, could
you try to run the same kernel on a mx6q development board, such as
mx6qsabresd, cubox-i, wandboard, etc?
