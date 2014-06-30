Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaF3M0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:26:03 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59714 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaF3M0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <53B14E9E.3040505@vmware.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
 <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
 <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com>
 <53B14E9E.3040505@vmware.com>
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Mon, 30 Jun 2014 08:25:40 -0400
Message-ID: <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 7:48 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> I don't think we can blame video-vmware for this. A kernel driver change
> that breaks existing user-space is by definition a kernel driver bug,
> regardless whether exisiting user-space is doing something horrendously
> stupid.

I wouldn't be so quick to say it's a kernel bug. The fbdev contract
hasn't changed. Also xf86-video-vmware isn't using the fbdev driver,
and the fbdev driver code is obviously correct (see screenshots in
link submitted with initial patch).

> So the fix must IMO be a kernel driver fix. My initial guess is that
> once we set the bytes per line register, it might not be automatically
> updated when the screen width is changed, but the documentation is poor.
> I see if I can shed some light over this.

Having dumped all of the svga registers while hacking on vmwgfx, I
noticed that the BYTES_PER_LINE field is initially incorrectly set to
something way off. My initial reaction is that video-vmware doesn't
properly compute the bytes-per-line register, and therefore that it is
a video-vmware bug that has always existed.

I'm reproducing the problem and providing a fix for video-vmware as I
write this.

C
