Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGHOCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:02:16 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56443 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHOCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:02:14 -0400
MIME-Version: 1.0
Date: Tue, 8 Jul 2014 09:02:14 -0500
Message-ID: <CAJgR-Bi2HX+aYVabaFLyu9QAnAS4RmQ7DvBtDHOawkfi08zycA@mail.gmail.com>
Subject: Questions About a Semi-Soft irqchip Device
From: Jon Loeliger <loeliger@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I have a few questions about an interrupt controller IP block
that I would like to support in an ARM SoC port.

My IP block provides software-assignable interrupts.  That
is, I have a large pool of interrupt sources, and a large pool
of interrupt bits in the controller, but they are not physically
tied together. Instead they are assigned by some driver as it
initializes and allocates resources.  This, I think, means that
I can not describe the interrupt  bindings in the DTS file.

So, my first question is:  Should I still write an irqchip device
for this IP block and represent it in the device tree, even
though I will not be able to use it as the referee of an
interrupt = < ... > binding?  I think I should primarily because
other drivers will still need to set up IRQ handling through
this device.

Another question:  This device has a muti-32-bit-word
bit-field representation for the interrupt lines.  It has a
parallel array of words for clearing the interrupt.  Is there
an existing irqchip that I can directly leverage that fits
that description?

Thank you,
jdl
