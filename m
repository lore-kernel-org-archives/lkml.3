Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaACRva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:51:30 -0500
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:58345 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751263AbaACRv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:51:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYMBq267qW59QtEY6b+-jmqafnWRsuZOG=9FWF=aUpRpA@mail.gmail.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
	<CACRpkdYMBq267qW59QtEY6b+-jmqafnWRsuZOG=9FWF=aUpRpA@mail.gmail.com>
Date: Fri, 3 Jan 2014 17:32:59 +0100
Message-ID: <CACh+v5Mfq5uC90tH2Q1BTr-f9Sa98Y0HkeYb=F3XChrEehupRQ@mail.gmail.com>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 16590416603555256344
X-Ovh-Remote: 209.85.192.175 (mail-pd0-f175.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/2 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Dec 19, 2013 at 7:52 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> On Tue, Dec 17, 2013 at 9:22 AM, Jean-Jacques Hiblot
>> <jjhiblot@traphandler.com> wrote:
>>>
>>> This patch implements a new tracing mechanism based on kprobes and using GPIO.
>>> Debugging with GPIO is very common in the embedded world. At least for those of us
>>> fortunate enough to have an oscilloscope or a logic analyzer on their bench...
>>> This is especially true if the issue results of a hardware/sofware interaction.
>>>
>>> Typical use cases are :
>>> * mixed software/hardware debugging. For example when the software detects a
>>>   situation of interest (typically an error) it toggles a GPIO to trigger the
>>>   oscilloscope acquisition.
>>> * direct latency/duration measurements.
>>>
>>> examples:
>>> To trig the oscilloscope whenever a mmc command error:
>>>   echo "p:my_mmc_blk_error mmc_blk_cmd_error gpiopulse@13" > /sys/kernel/debug/tracing/kprobe_events
>>>   echo 1 > /sys/kernel/debug/tracing/events/kprobes/my_mmc_blk_error/enable
>
> I've never seen the whole patch.
>
> Can you please repost this and include linux-gpio@vger.kernel.org and also
> me on the To: line?

Hello Linus,

I'll repost the patch.
It has evolved a bit since you've been included in the cc list. It's
now based upon the 'event trigger' and more important for you, it
doesn't request nor configure the GPIO before using it. The reason is
that how to do this is still being discussed with Alexandre.

Jean-Jacques

>
> Yours,
> Linus Walleij
