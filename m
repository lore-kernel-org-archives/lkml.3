Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3LOCzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:55:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3LOCze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:55:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Sun, 15 Dec 2013 03:55:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312150153.54044.arnd@arndb.de> <1387073571.13062.102.camel@host5.omatika.ru>
In-Reply-To: <1387073571.13062.102.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312150355.27755.arnd@arndb.de>
X-Provags-ID: V02:K0:AYs+m9imSY1H9eYXnzQ4i3Jb9RNpWBocsDRddScLlSd
 ZZIT6P3bttJkcWTV2D1cTKXYjM29fIy9KcGrDJoD+F+c9L2vgr
 PvmgMcZ2Jnx9d2vUY25Fbuvdd+qMl7HjNo5jLbhOHHA06nHWvF
 2mwoO3GyjJuJwdE7+lSqa4iCMfL4JbXYR/BpPLd6TUTKIIh3wp
 cPlEu7uHQf8dHcDHRVr9SY3xgn/SGTme6TFT7vcfjgQl//tPRl
 RfP04TlTnU0Hi2/Kaz9UG4UFNuUoc3LDeOULEGQ7o8T2d7JhDj
 4B7/pnw9XjSj9z8w4XTNajlEeTpbejuMMxyupt2kF/Zl8KbOEj
 MP5EFMQl9SKU2UABtPyo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 December 2013, Sergei Ianovich wrote:
> On Sun, 2013-12-15 at 01:53 +0100, Arnd Bergmann wrote:
> > On Saturday 14 December 2013, Sergei Ianovich wrote:
> > Unfortunately I don't have a good way to judge the tradeoffs without
> > understanding more about the design of the hardware. Did I understand
> > you right that you expect future versions of the FPGA bitstream
> > to implement additional features or have a different set of endpoint
> > devices?
> 
> I am trying to reduce time you spend on review as much as possible.
> Please feel free to say if I do something to the opposite.
> 
> I could write a lengthy description of the machine as I understand it,
> if need be. I am not related to its vendor in any way, so it may or may
> not be correct.
> 
> I've made to work 100% of features my client needs in the machine. It is
> ~80% of the devices on the frame and ~10% of possible slot modules.
> There are chances someone else will work on the rest, eg. the device
> vendor.
> 
> This page contains a photo, if there is any interest to see how it looks
> like:
> http://www.icpdas.com/root/product/solutions/pac/linpac/lp-8x4x_hardware.html

I see, thanks for the clarification.

> > If so, I would argue that anything that you consider an optional
> > sub-device should have its own device node in the device tree.
> > 
> > Also, do you have to model hardware that is connected to the FPGA
> > rather than being part of it?
> 
> Anything that can be plugged into the device is discoverable, so doesn't
> require to be in the device tree.

Ah, good.

> > I suspect that you may have a different understanding of the term
> > MFD than what I was suggesting: A typical MFD driver in Linux is
> > basically a container device that has some registers on its own
> > like a version detection or the irqchip but mainly is there to
> > create sub-devices that each have a subset of the available
> > registers. The sub-devices may or may not be describe in DT in this
> > case.
> 
> I may be missing something. My general understanding seems to be as
> follows. MFD will have probe/remove functionality of drivers for SRAM,
> RTC, serial modules in the patch series. MFD will be to FPGA what C
> language machine file was to machine: lots of hardcoded constants and
> functions which implement non-standard behavior (like set_termios in
> 8250_lp8x4x.c). This seems to be wrong to me, as device tree is
> specifically designed to handle platform device initialization.
> 
> The tree you drafted in the previous mail was 100% correct. I though
> about doing something like that. I decided not to, since all devices
> behind the FPGA are transparently accessed by CPU. I like the idea. I
> haven't resent a series with FPGA bus only because you wrote in the same
> mail that we need an MFD.
> 
> If you say so, we will have an MFD.

I think I was confused by the fact that the FPGA both has multiple
integrated devices and multiple pluggable devices. Given your explanations,
I think the way you have structured your code is good, and an MFD would
not help. Please just restructure the DT representation to contain the
external-bus and/or the fpga connected to it. You probably don't need both,
but it doesn't hurt to show them as different device-nodes either.
Your choice.

	Arnd
