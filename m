Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3CJPOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:14:30 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38838 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3CJPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:14:29 -0400
MIME-Version: 1.0
Date: Sun, 10 Mar 2013 16:14:27 +0100
Message-ID: <CAF2Nc0zT5t_YeqzJWprUH7ma3_3LCWVXgbxLBODU7drgauDt=Q@mail.gmail.com>
Subject: very strange dependencies on CONFIG_EXPERT=n in kernel 3.8
From: Konrad Vrba <konrad.vrba@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,
I have noticed that CONFIG_EXPERT=n makes the following options in the
kernel required (unremovable):

CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_I8253_LOCK=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_PCSPKR_PLATFORM=y

If I select CONFIG_EXPERT=y then I can remove those, but that creates
a new problem by making CONFIG_DEBUG_KERNEL=y unremovable.

To make a specific example, this makes it impossible to compile a kernel with
CONFIG_FW_LOADER=n
CONFIG_DEBUG_KERNEL=n
at the same time

I am not a kernel developer, but I can see no logical reason why that
should be so.
Could somebody please comment on this? I hope my question makes sense.

Cheers,
Konrad
