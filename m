Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3BQWCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:02:20 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:43458 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3BQWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Date: Mon, 18 Feb 2013 08:02:16 +1000
Message-ID: <CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
Subject: Re: [PATCH 0/9] System Framebuffer Bus (sysfb)
From: Dave Airlie <airlied@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This series tries to fix the mess with global system framebuffer access in
> device drivers. Currently, architecture initialization sets the "screen_info"
> object according to the system framebuffer that was detected during boot. The
> device driver that can map VMEM first gets access to it. There is no way to give
> a specific driver access to the device and no _proper_ way to revoke access
> again. In fact, some drivers don't even check whether they mapped the VMEM
> successfully, letting multiple drivers to access the system framebuffer at the
> same time.

I'm unsure if I like this or not, and I don't see why its greatly more
useful than the interface we have now.

It doesn't solve the main problem with the current interface, which is
that if somebody opens has vesafb /dev/fb0, mmaps it, and modprobes a
real driver, things will fail either miserably or crappy from a users
pov.

The internal reference counts stop vesafb from unloading due to the
mmaps, then i915 loads anyways and one bashes the other, or we fix so
i915 doesn't load and the user gets fail.

Dave.
