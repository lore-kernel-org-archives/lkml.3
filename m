Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaCVOOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 10:14:34 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47523 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaCVOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 10:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <201403221054.39799.arnd@arndb.de>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
	<201403221054.39799.arnd@arndb.de>
Date: Sat, 22 Mar 2014 09:14:31 -0500
Message-ID: <CAL_JsqKjGjyYypwneCmNc1qeKe0ZOG9gz3QSJ37-HwHXKu3iRA@mail.gmail.com>
Subject: Re: [PATCH 0/8] Generic serial earlycon
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 4:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 21 March 2014, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> This started out as an attempt to add arm64's earlyprintk support to ARM
>> in order to get an earlier, runtime setup console on multi-platform
>> kernels. The first issue was needing the fixmap support which
>> conveniently Mark Salter was working on and is mostly in place now. Like
>> many things on ARM and arm64 now, it then became where do I put the now
>> common, shared code. After digging more into various early console/printk
>> support, it turns out the 8250_early.c setup code was the best starting
>> point.
>>
>> This is based on Mark Salter's fixmap support currently in linux-next.
>> This is tested on arm64 and ARM with pl011 and 8250. The ARM support
>> also requires fixmap and fixed mapping support which are not yet in place.
>> I have some patches in my tree to support fixmap, but they need some more
>> work. Fortunately, once fixmap is in place, it is just a Kconfig option
>> to enable earlycon support on ARM. A git tree is available here[1].
>>
>> Based on this series, I would like to add support for doing earlycon
>> setup using DT.
>
> Hi Rob,
>
> I like this series a lot, great work!
>
> I would consider the DT parsing support essential here, we should not
> merge the patches until that is done as well, because I don't want
> to see users pass earlycon command line options in DT when they can
> use the established "linux,stdout-path" property instead. I would
> expect that in almost every case in which we are booting using DT
> today, we can just use linux,stdout-path to locate the device that
> the boot loader has already set up and start usign it.

I think this series stands on its own. It is largely refactoring
existing code and supporting existing command line options (arm64 just
changes from earlyprintk= to earlycon=). There will be cases where
changing the kernel command line is the only way to setup the
earlycon. Also, I think we would still want the kernel command line to
control whether or not we enable the earlycon (i.e. earlycon=dt).
There's not a standard way for how bootloaders would decide to set
"linux,stdout-path" or not.

The DT support won't be all that quick to implement. The challenge
with the DT parsing is we have to do it on the flattened DT. I have
something functioning, but it doesn't do any address translation which
is the hard part.

Rob
