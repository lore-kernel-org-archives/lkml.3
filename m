Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaFMV6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:58:53 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35900 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaFMV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com>
References: <1402689965-19397-1-git-send-email-jwerner@chromium.org>
	<CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com>
Date: Fri, 13 Jun 2014 14:58:51 -0700
X-Google-Sender-Auth: UzK63jjOyefdhrldQOC7XOsCT1A
Message-ID: <CAODwPW9tRM8kxBVg3apkec2K1rahuENk_b_BD_0jvXON7JzeaA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Add device tree binding for coreboot
From: Julius Werner <jwerner@chromium.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Julius Werner <jwerner@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <stephen.r.warren@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Stefan Reinauer <stefan.reinauer@coreboot.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is just to export a fixed log to userspace (like a DMI table) or
> the kernel will actually use the data in some way? Based on the link,
> it looks like the former to me.

I could imagine both. The link is an in-kernel driver that exposes a
log through a sysfs node (in a way that has already been established
on x86 systems, which find the location through EBDA or ACPI entries
instead). We are also using a user-space tool that reads the address
from /proc/device-tree and accesses it through /dev/mem. The areas can
contain many interesting entries (like the location of an early
framebuffer set up by the firmware), so I could also imagine use cases
where the kernel makes use of it directly.

> Don't you need need to keep the kernel from allocating this memory by
> using one of the reserved memory mechanisms? The recently added one
> should be able to specific what the memory is reserved for IIRC.

Our bootloader is carving the location out of the /memory node and
adding it to the device tree reserve map. As far as I know, that only
contains a list of raw start and size entries. At any rate, I think
it's useful (and in line with other bindings) to add a more explicit
node like this (if only to make it easier accessible through
/proc/device-tree).

> /firmware is already used IIRC. What if you have other firmware such
> as Trustzone?

I'm not quite sure how Trusted Foundations works and whether it would
even make sense to use it in parallel to coreboot, but it seems to be
using the /firmware/trusted-foundations subnode so that should be
fine. "firmware" seems to be used by other firmware implementations
(like "samsung,secure-firmware") which are similar in nature to and
mutually exclusive with coreboot, so I thought the node makes sense.
(The kernel should use the compatible string to find it anyway, so a
future name clash would not be world-ending.)
