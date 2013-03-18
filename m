Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3CRKF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:05:29 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42735 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3CRKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:05:27 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
Date: Mon, 18 Mar 2013 11:05:26 +0100
Message-ID: <CAKMK7uE9o7CT4Bn1SrPyCa+bGrHmj2-+cpDYP__gUU+BRiGH7A@mail.gmail.com>
Subject: Revert a bunch of patches in stable kernels
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg&all,

So a recent stable backport to fix rc6 on ilk (which is disabled by
default and with dubious power savings at best, unlike rc6 on snb and
later) totally blew up all over the place:
https://bugzilla.kernel.org/show_bug.cgi?id=55291
https://lkml.org/lkml/2013/3/14/540

There might be more, I'm still recovering from mail floods due to
traveling last week. I think the right course of action is to revert
the offending patch (plus anything depending upon it) and give up on
rc6 on ilk in 3.8 - too messy. All bug reports confirmed that 3.9-rc
kernels work as expected. Upstream commits to revert:

15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 drm/i915: enable irqs earlier
when resuming
52d7ecedac3f96fb562cb482c139015372728638 drm/i915: reorder setup
sequence to have irqs for output setup

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
