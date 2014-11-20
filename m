Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbaKTSJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:09:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41391 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbaKTSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:09:14 -0500
Message-ID: <546E2E3E.5040305@gmail.com>
Date: Thu, 20 Nov 2014 10:09:02 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Jon Fraser <jfraser@broadcom.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 00/22] Multiplatform BMIPS kernel
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <20141120030434.GE24364@ld-irv-0074> <CAJiQ=7C8h-MAuRdgzZqx2=bg8bvy7v9pv7e7tGXWmA9ghYJiqQ@mail.gmail.com>
In-Reply-To: <CAJiQ=7C8h-MAuRdgzZqx2=bg8bvy7v9pv7e7tGXWmA9ghYJiqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 07:55 PM, Kevin Cernekee wrote:
> On Wed, Nov 19, 2014 at 7:04 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> On Sat, Nov 15, 2014 at 04:17:24PM -0800, Kevin Cernekee wrote:
>>> The lack of a reboot handler is annoying; syscon-reboot probably won't work
>>> on STB (because it requires two writes).
>>
>> Can't you reuse drivers/power/reset/brcmstb-reboot.c ?
> 
> Oops, I ran a quick check earlier by grepping for "sun-top-ctrl" and
> looking under drivers/reset, but assumed this driver wasn't merged yet
> when nothing came up in the code.  Thanks for the pointer.
> 
> It looks like the current driver will work for 40nm, but 65nm uses
> different bit positions: RESET_CTRL bit 3 to arm, and SW_RESET bit 31
> to trigger.  I'll add a new "brcm,brcmstb-reboot-65nm" compatible
> string to make this work.
> 
> Also, we'll need to take Guenter Roeck's register_restart_handler()
> patch in order to build on MIPS.

Slightly unrelated, did you also try to use drivers/bus/brcmstb_gisb.c
on these MIPS platforms?

Its usefulness is probably lower on MIPS since we typically get accurate
bus errors to be decoded by the CPU and printed through the exception
handler, but I'd be curious if it works just fine as well.

Thanks!
--
Florian
