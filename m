Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbaGBCGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 22:06:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44216 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaGBCGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 22:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <53B13B0B.5030809@mev.co.uk>
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
	<53B13B0B.5030809@mev.co.uk>
Date: Tue, 1 Jul 2014 21:06:16 -0500
Message-ID: <CA+jnaaX74EiA5QZkg7W+nt=EBp9DSJc-pcHED3zj-mFkVMh=8w@mail.gmail.com>
Subject: Re: [PATCH 0/3] staging: comedi: addi_apci_1564: miscellaneous fixes
 and cleanups
From: Chase Southwood <chase.southwood@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        hsweeten@visionengravers.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, Jun 30, 2014 at 5:25 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 2014-06-28 05:47, Chase Southwood wrote:
>>
>> This patchset moves a misplaced include to the proper file, swaps out an
>> overly
>> aggressive placement of apci1564_reset(), and cleans up
>> apci1564_interrupt().
>>
>> Chase Southwood (3):
>>    staging: comedi: addi_apci_1564: move addi_watchdog.h include to
>>      addi_apci_1564.c
>>    staging: comedi: addi_apci_1564: fix use of apci1564_reset() to
>>      disable DI interrupts
>>    staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
>>
>
> It's okay, but I think you can simplify the interrupt handling a bit more by
> not bothering to check for interrupts from unknown sources.   If a source
> hasn't been enabled, it shouldn't generate interrupts, right? Besides, since
> the does nothing to stop further interrupts from unknown sources, it would
> just keep getting further interrupts repeatedly in that case.
>
> Then you can get rid of the ui_DO, ui_DI, ui_Timer, and counters[] variables
> and just check the registers directly (e.g. replace 'if (ui_Timer == 1)'
> with 'if (inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG) & 0x01)').

I received some more good comments about the interrupt function, and
looks like Greg is on vacation this week anyway, so I think I will
just redo patch 3 and send out a v2 patchset.

Thanks,
Chase
