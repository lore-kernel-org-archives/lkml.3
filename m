Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaKTDzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:55:37 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41548 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaKTDzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:55:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141120030434.GE24364@ld-irv-0074>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <20141120030434.GE24364@ld-irv-0074>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 19 Nov 2014 19:55:15 -0800
Message-ID: <CAJiQ=7C8h-MAuRdgzZqx2=bg8bvy7v9pv7e7tGXWmA9ghYJiqQ@mail.gmail.com>
Subject: Re: [PATCH V2 00/22] Multiplatform BMIPS kernel
To: Brian Norris <computersforpeace@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 7:04 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Sat, Nov 15, 2014 at 04:17:24PM -0800, Kevin Cernekee wrote:
>> The lack of a reboot handler is annoying; syscon-reboot probably won't work
>> on STB (because it requires two writes).
>
> Can't you reuse drivers/power/reset/brcmstb-reboot.c ?

Oops, I ran a quick check earlier by grepping for "sun-top-ctrl" and
looking under drivers/reset, but assumed this driver wasn't merged yet
when nothing came up in the code.  Thanks for the pointer.

It looks like the current driver will work for 40nm, but 65nm uses
different bit positions: RESET_CTRL bit 3 to arm, and SW_RESET bit 31
to trigger.  I'll add a new "brcm,brcmstb-reboot-65nm" compatible
string to make this work.

Also, we'll need to take Guenter Roeck's register_restart_handler()
patch in order to build on MIPS.
