Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaHKUfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:35:06 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:38425 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaHKUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:35:04 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:28a4:d7e2:1da8:e877]
In-Reply-To: <20140811195137.GB3711@ld-irv-0074>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
	<1407516479-1251-3-git-send-email-olof@lixom.net>
	<20140811195137.GB3711@ld-irv-0074>
Date: Mon, 11 Aug 2014 13:35:03 -0700
Message-ID: <CAOesGMhXJGeSKwtty=Jr6DUMFFpQYRsBBzE_bFOwB5vaP7=iFQ@mail.gmail.com>
Subject: Re: [GIT PULL 2/7] ARM: SoC platform changes for 3.17
From: Olof Johansson <olof@lixom.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:51 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> + other involved parties
>
> On Fri, Aug 08, 2014 at 09:47:54AM -0700, Olof Johansson wrote:
>> This is the bulk of new SoC enablement and other platform changes for 3.17:
> [...]
>> * Broadcom BCM7xxx settop box chipset is introduced
> [...]
>> Marc Carino (1):
>>       ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
>
> I realize this is a bit late (the pull request is already merged), but
> I'd like to be up-front about this: there were some (late) oustanding
> review comments made on this patch [1]. I have a few patches queued
> locally for addressing many of them, but not all of the issues are
> completely resolved.
>
> Shall I simply send a revert patch for the
> arch/arm/mach-bcm/platsmp-brcmstb.c stuff, and get it in through the
> bcm -> arm-soc -> Linus merge path in 3.17-rcX? Or should I take the
> incremental improvement approach, as we have functioning code with no
> clear alternative proposal yet?

Yeah, looks like the discussion happened the first day I was on
vacation and I missed the thread in the backlog. :(

Looks like all the outstanding issues are with the SMP support. How
about you send a patch that removes/stubs those portions? It won't be
a pure revert since as mentioned in the thread SMP was combined with
platform support, but that's OK.

That way the basic platform stuff can still go in for 3.17, and we can
re-queue the SMP pieces for 3.18 once things are sorted out.


-Olof
