Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145Ab3DCPHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:07:01 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48022 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829Ab3DCPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130403042142.GA3640@roeck-us.net>
References: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
	<1364795972-8649-2-git-send-email-tonychung00@gmail.com>
	<20130402000741.GA4077@roeck-us.net>
	<CAHyaeP1ExzMr8_KvSrmf6+urVROEHRePs_KA3CZ3bnU6Ov79LQ@mail.gmail.com>
	<20130403042142.GA3640@roeck-us.net>
Date: Wed, 3 Apr 2013 08:06:59 -0700
Message-ID: <CAHyaeP1tdNpqtOLOYpy-OyL2_myPSQAO3eQF5_k9ryuFW6bhAQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] watchdog: fix w83627hf_wdt clear timeout expired
From: Tony Chung <tonychung00@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 9:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:

>
>
> What is the exact chip type in your system ? I want to have a look into the
> datasheet; maybe I can find out how it can trigger without causing a reset.

Winbond 83627HF chip

I believe BIOS has watchdog disabled otherwise it would have reboot the box.
However, the timer just start counting.

Comparing to ipmi_watchdog, you can do this:
modprobe ipmi_watchdog ... start_now=0 ...action=<>  nowayout=1

So it is possible to load the driver without start counting.

Notice it is an else, so t is actually 0 already (i.e. expired or
never start running):
> +     } else {
> +             outb_p(0, WDT_EFDR);    /* disable to prevent reboot */


--
- Tony Chung
