Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3IMQYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:24:01 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55805 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3IMQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130913161820.GM19363@lunn.ch>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<0a512914fd48b2d6db685446f88b9a096eff79a1.1379063063.git.viresh.kumar@linaro.org>
	<20130913161820.GM19363@lunn.ch>
Date: Fri, 13 Sep 2013 21:53:58 +0530
Message-ID: <CAKohpo=7FbGkq=vQLjoha3yxvKZomsgLdvf+SMYnPt4jsSk67Q@mail.gmail.com>
Subject: Re: [PATCH 195/228] cpufreq: kirkwood: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2013 21:48, Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Sep 13, 2013 at 06:32:21PM +0530, Viresh Kumar wrote:
>
>> -     if (freqs.old != freqs.new) {
>> -             local_irq_disable();
>> -
>> -             /* Disable interrupts to the CPU */
>> -             reg = readl_relaxed(priv.base);
>> -             reg |= CPU_SW_INT_BLK;
>> -             writel_relaxed(reg, priv.base);
>> -
>> -             switch (state) {
>> -             case STATE_CPU_FREQ:
>> -                     clk_disable(priv.powersave_clk);
>> -                     break;
>> -             case STATE_DDR_FREQ:
>> -                     clk_enable(priv.powersave_clk);
>> -                     break;
>> -             }
>
> Hi Viresh
>
> I see you removed the test that the old and the new frequency are
> different. Is this guaranteed by the core? Because if not, you can
> lockup the CPU. The call to cpu_do_idle() will never return.

Yes, that's guaranteed by core: patch 181..
