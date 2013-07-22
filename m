Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3GVVTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:19:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41708 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab3GVVTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:19:31 -0400
Date: Mon, 22 Jul 2013 23:19:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH -v2] RTC: Add an alarm disable quirk
Message-ID: <20130722211927.GD4613@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
 <20130719213458.GF19581@pd.tnic>
 <20130720170023.GB13731@pd.tnic>
 <51ED9D7A.1050201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51ED9D7A.1050201@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 02:00:42PM -0700, John Stultz wrote:
> Also, just to clarify, on the affected machines, with this patch,
> wake-up alarm's will in effect be disabled, right?

See below.

> >@@ -385,6 +418,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
> >  	if (!is_valid_irq(cmos->irq))
> >  		return -EINVAL;
> >+	if (!disable_alarm)
> >+		return 0;
> >+
> 
> Did you want this in cmos_alarm_irq_enable? Or cmos_irq_disable?

You're right - the first version did call it only in rtc_alarm_disable()
so I should move it to cmos_alarm_disable(). Will fix.

Btw, I did some more runs on the weekend. It seems, the setting of the
alarm interrupt bit in RTC_CONTROL doesn't matter. I dumped its contents
on shutdown and I had cases where it was 0x22 (bit 5 set) and 0x2.

So my hunch currently is us *not* disabling the alarm, doesn't make it
reboot the box.

I know, unfortunately this is still a brown paper bag and I don't have a
real rootcause...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
