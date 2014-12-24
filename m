Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaLXVyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:54:06 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41462 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaLXVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:54:03 -0500
Date: Wed, 24 Dec 2014 15:53:53 -0600
From: Michael Welling <mwelling@emacinc.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, acourbot@nvidia.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Roland Stigge <stigge@antcom.de>,
        Wolfgang Grandegger <wg@grandegger.com>, tstratman@emacinc.com
Subject: Linux GPIO internals
Message-ID: <20141224215352.GA26482@sysresccd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

For years now EMAC has provided an out-of-tree series of class drivers
for accessing various devices. The EMAC GPIO class and character
interfaces predate the introduction of the gpiolib interface and have
been ported across several kernel versions.

http://wiki.emacinc.com/wiki/Using_the_EMAC_GPIO_Class

Recently we have come to the conclusion that continuing to provide
support for these drivers is getting out of hand. It was agreed that we
move away from our non-standard drivers and use mainstream drivers for our
newest products.

That being said, we would like to be able to provide the capabilities
of our old drivers but it is not the case with the current gpiolib
implementation.

Here are the major concerns that we have with the gpiolib implementation:
- There is no mechanism to provide simultaneous access to multiple
  GPIOs from userspace. 
- The sysfs interface seems to vastly slower than the character
  interface and it is far more cumbersome to handle access from a
  userspace C program.

It seems that the first concern was attempted to be addressed by the
following patch:
https://lkml.org/lkml/2012/12/23/66

It seems this effort dropped off the radar in January of 2013.
What happened to this patch?

As for the second issue, I am not sure how to resolve this and am open
to ideas. I have seen similar concerns in other subsystem that use the
sysfs interface.

IIO example: 
http://www.spinics.net/lists/linux-iio/msg15344.html

Suggestions?

