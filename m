Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450Ab3E2Jeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:34:44 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61237 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353Ab3E2Jen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130529085426.GA13095@mudshark.cambridge.arm.com>
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
 <20130528130502.GA28971@mudshark.cambridge.arm.com> <51A4B938.7080708@ti.com>
 <20130528140705.GE28971@mudshark.cambridge.arm.com> <51A4FC08.3060906@ti.com>
 <CANutaR-2gTP7ubiEdgjFyzVMc6=4t5GPjLkH8pkup=O882Hb-Q@mail.gmail.com> <20130529085426.GA13095@mudshark.cambridge.arm.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 29 May 2013 17:34:01 +0800
Message-ID: <CANutaR_8jNDzPeyJ8PLZPS=yiZ8Ywmk08dR9vLcB2CpxuJac3A@mail.gmail.com>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
To: Will Deacon <will.deacon@arm.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Wed, May 29, 2013 at 4:54 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, May 29, 2013 at 03:14:58AM +0100, Po-Yu Chuang wrote:
>> Will,
>> I guess nobody noticed this because the MMU of later v7 processors
>> fetches page table
>> from D-cache. It even doesn't need to clean pmd to PoU.
>
> It does if it's UP. The walker is only guaranteed to read from L1 if you
> have the multiprocessing extensions.

Ya, I see.

>
> As for this function, looks like it's ok because it has precisely one
> caller, so it might be worth prefixing it with some underscores to make it
> clear that nobody else should be calling it!

I am fine with that.
Should I create a new patch?

Regards,
Po-Yu
