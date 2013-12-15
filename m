Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3LOCM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:12:56 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:61372 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LOCMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:12:55 -0500
Message-ID: <1387073571.13062.102.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Sun, 15 Dec 2013 06:12:51 +0400
In-Reply-To: <201312150153.54044.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312142203.45740.arnd@arndb.de>
	 <1387058146.13062.24.camel@host5.omatika.ru>
	 <201312150153.54044.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-15 at 01:53 +0100, Arnd Bergmann wrote:
> On Saturday 14 December 2013, Sergei Ianovich wrote:
> > There are basically 2 options: one-for-all mfd device and one-for-one
> > device drivers.
> > 
> > MFD
> > pros:
> > * easy to add into the tree (one file)
> > * easy config (one option)
> > 
> > Separate devices
> > * easy to support devices as respective subsystems evolve
> > * easy to add new feature without breaking existing ones. Eg. it may
> > make sense to provide industrial IO interface on analog IO devices
> > * possible to have fine-grained configuration (eg. SRAM in kernel,
> > serial and slot as modules)
> > * proper device tree serves as a datasheet for the machine, so anyone
> > who needs to work on it will have a decent view of the internals
> > 
> > I believe long-term benefits of separate devices outweigh immediate
> > effects of an MFD. However, I certainly don't see the big picture and
> > will accept your decision. Please make one.
> 
> Unfortunately I don't have a good way to judge the tradeoffs without
> understanding more about the design of the hardware. Did I understand
> you right that you expect future versions of the FPGA bitstream
> to implement additional features or have a different set of endpoint
> devices?

I am trying to reduce time you spend on review as much as possible.
Please feel free to say if I do something to the opposite.

I could write a lengthy description of the machine as I understand it,
if need be. I am not related to its vendor in any way, so it may or may
not be correct.

I've made to work 100% of features my client needs in the machine. It is
~80% of the devices on the frame and ~10% of possible slot modules.
There are chances someone else will work on the rest, eg. the device
vendor.

This page contains a photo, if there is any interest to see how it looks
like:
http://www.icpdas.com/root/product/solutions/pac/linpac/lp-8x4x_hardware.html

> If so, I would argue that anything that you consider an optional
> sub-device should have its own device node in the device tree.
> 
> Also, do you have to model hardware that is connected to the FPGA
> rather than being part of it?

Anything that can be plugged into the device is discoverable, so doesn't
require to be in the device tree.

> I suspect that you may have a different understanding of the term
> MFD than what I was suggesting: A typical MFD driver in Linux is
> basically a container device that has some registers on its own
> like a version detection or the irqchip but mainly is there to
> create sub-devices that each have a subset of the available
> registers. The sub-devices may or may not be describe in DT in this
> case.

I may be missing something. My general understanding seems to be as
follows. MFD will have probe/remove functionality of drivers for SRAM,
RTC, serial modules in the patch series. MFD will be to FPGA what C
language machine file was to machine: lots of hardcoded constants and
functions which implement non-standard behavior (like set_termios in
8250_lp8x4x.c). This seems to be wrong to me, as device tree is
specifically designed to handle platform device initialization.

The tree you drafted in the previous mail was 100% correct. I though
about doing something like that. I decided not to, since all devices
behind the FPGA are transparently accessed by CPU. I like the idea. I
haven't resent a series with FPGA bus only because you wrote in the same
mail that we need an MFD.

If you say so, we will have an MFD.

