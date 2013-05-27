Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3E0K4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:56:31 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38001 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab3E0K4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:56:30 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv4 4/6] clocksource: TI-Nspire timer support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <CACRpkda4Qe1e+dkcSgPLf5dcHASvOG=Y=Dvrnv=oGnon+FRzzg@mail.gmail.com>
Date: Mon, 27 May 2013 20:56:24 +1000
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7BIT
Message-Id: <69E1F2A1-CD4C-4B16-8664-6010C7217B8B@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <1369480087-24786-5-git-send-email-dt.tangr@gmail.com> <CACRpkda4Qe1e+dkcSgPLf5dcHASvOG=Y=Dvrnv=oGnon+FRzzg@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/2013, at 8:53 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> On Sat, May 25, 2013 at 1:08 PM, Daniel Tang <dt.tangr@gmail.com> wrote:
> 
>> Add clocksource and clockevent driver for the TI-Nspire.
>> 
>> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> 
> This is *much* improved :-D

Awesome!

>> +               /* Disable timer interrupts */
>> +               writel(0, timer->interrupt_regs + IO_INTR_MSK);
>> +               writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
>> +               /* Stop timer */
>> +               writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
>> +               dev->mode = mode;
>> +               break;
>> +       }
> 
> Surely both the compiler and checkpatch is complaining that this
> switch does not contain a default: clause?

Neither in fact. checkpatch.pl gives me a all-clear.

But, I'll clean it up anyway - seems cleaner that way XD.

> 
> If you fix this you can add my:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

Cheers,
Daniel Tang