Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaETB0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:26:35 -0400
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:52289 "HELO
	exprod5og122.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932070AbaETB0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <878upynlz4.fsf@approximate.cambridge.arm.com>
References: <1400278813-3048-1-git-send-email-fkan@apm.com>
	<1400278813-3048-3-git-send-email-fkan@apm.com>
	<878upynlz4.fsf@approximate.cambridge.arm.com>
Date: Mon, 19 May 2014 18:26:33 -0700
Message-ID: <CAL85gmByuxTdPWaDZENDz=rKQtfZc44eUaCsnK04DfeXknAoYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
From: Feng Kan <fkan@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #ifdef CONFIG_CPU_PM
>> @@ -613,7 +636,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>                                       dist_base + GIC_DIST_PRI + i * 4);
>>
>>       writel_relaxed(GIC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
>> +     gic_cpu_if_up();
>
> Have you tested the save/restore path? It seems that we dont save
> GICC_CTLR, so it may not do what you think it will...

We are debating which is the better method. Currently we are only
disabling the GIC distributor so it is not a problem. Later on, with
more
aggressive PM we could have the helper core to setup the GIC CTLR prior to
releasing out of the PM state. However, it seems it would be more
cleaner if we save off the GIC_CTLR bits in the gic_cpu_save. This
would add additional items in to the gic_chip_data. Would you be open
to that?

>
>>  }
>>
>>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,      void *v)
>
> --
> Jazz is not dead. It just smells funny.
