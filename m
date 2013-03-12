Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3CLOw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:52:27 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33096 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3CLOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130311184916.GA6185@jtriplet-mobl1>
References: <CAF2Nc0zT5t_YeqzJWprUH7ma3_3LCWVXgbxLBODU7drgauDt=Q@mail.gmail.com>
	<20130311184916.GA6185@jtriplet-mobl1>
Date: Tue, 12 Mar 2013 15:52:24 +0100
Message-ID: <CAF2Nc0zSaXMkm-gkO9NqcAOubqSrZcBGeBeENo-jVZ+mo00ocQ@mail.gmail.com>
Subject: Re: very strange dependencies on CONFIG_EXPERT=n in kernel 3.8
From: Konrad Vrba <konrad.vrba@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Josh,
unfortunately, I cannot live with CONFIG_DEBUG_KERNEL. I need a
minimalistic kernel, and every unnecessary KB is expensive. Besides, I
have ideological objections to having unneeded features compiled in my
kernel.
Is there any way of editing it directly in the .config file manually?

Nobody asked for my opinion, but I feel I have to say something:
The linux kernel project is already a complicated endeavor as it is.
Why does somebody complicate it needlessly, by creating these
artificial problems. I very much appreciate the good work that is
being done on the linux kernel, but it seems to me that some people
have lost their common sense

Konrad

On 3/11/13, Josh Triplett <josh@joshtriplett.org> wrote:
> On Sun, Mar 10, 2013 at 04:14:27PM +0100, Konrad Vrba wrote:
>> Dear list,
>> I have noticed that CONFIG_EXPERT=n makes the following options in the
>> kernel required (unremovable):
>>
>> CONFIG_FW_LOADER=y
>> CONFIG_EXTRA_FIRMWARE=""
>> CONFIG_MOUSE_PS2_ALPS=y
>> CONFIG_MOUSE_PS2_LOGIPS2PP=y
>> CONFIG_MOUSE_PS2_SYNAPTICS=y
>> CONFIG_MOUSE_PS2_LIFEBOOK=y
>> CONFIG_MOUSE_PS2_TRACKPOINT=y
>> CONFIG_VGA_ARB=y
>> CONFIG_VGA_ARB_MAX_GPUS=16
>> CONFIG_I8253_LOCK=y
>> CONFIG_DEBUG_MEMORY_INIT=y
>> CONFIG_PCSPKR_PLATFORM=y
>>
>> If I select CONFIG_EXPERT=y then I can remove those, but that creates
>> a new problem by making CONFIG_DEBUG_KERNEL=y unremovable.
>>
>> To make a specific example, this makes it impossible to compile a kernel
>> with
>> CONFIG_FW_LOADER=n
>> CONFIG_DEBUG_KERNEL=n
>> at the same time
>
> CONFIG_DEBUG_KERNEL, like CONFIG_EXPERT, should not directly affect the
> code included in the kernel; it should just avoid asking about a pile of
> other debugging options.  In practice, a small amount of
> architecture-specific code (for powerpc, parisc, and blackfin) did use
> it as a generic debug option, but that needs fixing.  So, for now, turn
> on CONFIG_EXPERT and live with having CONFIG_DEBUG_KERNEL turned on.
>
> That aside, several of the above options should not depend on EXPERT;
> why would PCSPKR_PLATFORM or DEBUG_MEMORY_INIT need to depend on EXPERT?
>
> - Josh Triplett
>
