Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaAGUMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:12:24 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53004 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaAGUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:12:17 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <Pine.LNX.4.44L0.1401071341180.1296-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1401071341180.1296-100000@iolanthe.rowland.org>
Date: Tue, 7 Jan 2014 21:12:16 +0100
Message-ID: <CAKMK7uFEzOKYjojVop1ouRsJWyeK-rnKH-udBxZcc9fwKCOV6w@mail.gmail.com>
Subject: Re: Excessive WARN()s in Intel 915 driver
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 7:50 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> After all, it's not like there's anything I can do to fix the hardware,
> is there?  And it doesn't look like the pipe state mismatch is going to
> go away by itself.  Or is this a genuine, fixable, software bug?

These are genuine software bugs - every time one of these WARNs fires
our software tracking and the actual hardware state have diverged,
which eventually will lead to really subtle and hard to reproduce
bugs.

> In any case, wouldn't it be good enough for this message to be
> dev_warn() instead of WARN()?

I really want users to report these issues, and excessive WARNs seems
to be the only way to get those reports. Please boot with
drm.debug=0xe added to your kernel cmdline and reproduce this issues.
Also, which precise kernel are you running? Testing latest -rc is
always recommended, this state checker code is fairly new and gets
constantly extended and bugs fixed ...

Yours, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
