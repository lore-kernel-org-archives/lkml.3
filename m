Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaCWTtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:49:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:55055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaCWTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:49:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/8] Generic serial earlycon
Date: Sun, 23 Mar 2014 20:49:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com> <201403222301.30222.arnd@arndb.de> <CAL_Jsq+j4ixVbfue62q_tOHb-HPA2jAxwZtTjtLy6jE9crGvsg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+j4ixVbfue62q_tOHb-HPA2jAxwZtTjtLy6jE9crGvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403232049.41866.arnd@arndb.de>
X-Provags-ID: V02:K0:MxmsM7n5dco9x6stX8T4xZVDt4REJEAq0VNdsMFdm41
 odY67dd6W++GTfApqkj9NOw27bVhT6tQ1cpFOTvTphNWwzux5l
 mFdCMUPTp234bPdZeZodY8cTpvXmcKh3gcpIBvjsBxgXP1guqx
 jo0h+Dr2EJcUoFuNgRHZ1kAXG5P9oHogvo21+YPeOeT3FY2sJf
 x3Qnico+GT+cXh654iqZDoE/CCzbIQTuoJ5Cqvz8msYTTYVn7V
 re6klh0drtdbCkx0zWxyKKFA02y1ZyfYrFtWES+WlTs7zllhXm
 fwlovsmYIq5B9X1zyK177DOtagqzqbXv2Q52lhyYXwJUDcEhaj
 OMYxhC95/nt/HpgzIrJz3R5MLmfwkWL7vT53nhziA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 March 2014, Rob Herring wrote:
> IIRC, the unflattening cannot be done before memblock is up which is
> in arm_memblock_init. I believe that will get done earlier similar to
> PPC with Laura's meminfo removal series. However, in interest of
> getting output enabled as early as possible, the earliest point is
> always going to be with a flat tree. So I think we do want to be able
> to parse the flat tree for this. There's code in u-boot to do the
> address translation on FDT we can steal. Really, i'd like to put that
> code in libfdt, but there's a licensing problem with the u-boot code
> being GPL and libfdt being BSD.

I suppose it depends on what the goal is. If you are trying to get as
close as possible to the debug_ll functionality without losing the
ability to turn it on unconditionally, I agree that it needs to be done
on the flat tree.

However, the goal that interests me more at the moment is to have
reliable debug output done in a simple way earlier than what we have
today with the normal console support. For this, it seems a better
tradeoff to initialize the early console slightly later. This
can actually be done independent of the the command line option,
I don't see any downsides from having a compile-time option that
would initialize the early console from setup_arch (after
unflatten_device_tree) whenever there is a linux,stdout-path
property that points to a usable device.

	Arnd
