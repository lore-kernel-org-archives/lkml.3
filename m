Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171Ab3DCPuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:50:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53168 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761095Ab3DCPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:50:21 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Apr 2013 08:50:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] watchdog: fix w83627hf_wdt clear timeout expired
Message-ID: <20130403155026.GA4549@roeck-us.net>
References: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
 <1364795972-8649-2-git-send-email-tonychung00@gmail.com>
 <20130402000741.GA4077@roeck-us.net>
 <CAHyaeP1ExzMr8_KvSrmf6+urVROEHRePs_KA3CZ3bnU6Ov79LQ@mail.gmail.com>
 <20130403042142.GA3640@roeck-us.net>
 <CAHyaeP1tdNpqtOLOYpy-OyL2_myPSQAO3eQF5_k9ryuFW6bhAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHyaeP1tdNpqtOLOYpy-OyL2_myPSQAO3eQF5_k9ryuFW6bhAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 08:06:59AM -0700, Tony Chung wrote:
> On Tue, Apr 2, 2013 at 9:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> >
> >
> > What is the exact chip type in your system ? I want to have a look into the
> > datasheet; maybe I can find out how it can trigger without causing a reset.
> 
> Winbond 83627HF chip
> 
> I believe BIOS has watchdog disabled otherwise it would have reboot the box.
> However, the timer just start counting.
> 
> Comparing to ipmi_watchdog, you can do this:
> modprobe ipmi_watchdog ... start_now=0 ...action=<>  nowayout=1
> 
> So it is possible to load the driver without start counting.
> 
That is a different driver, though. you don't have the start_now option here.

> Notice it is an else, so t is actually 0 already (i.e. expired or
> never start running):

Still no idea why that would cause the system to reboot when you reset
the trigger without setting t to 0 again (or why the system doesn't reset
in the first place if the watchdog already triggered).

I am not really sure what the best approach is here, so let's leave it
up to the maintainer to decide which way to go.

Thanks,
Guenter
