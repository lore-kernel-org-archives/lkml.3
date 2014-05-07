Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaEGQPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:15:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45395 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaEGQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:15:38 -0400
Date: Wed, 7 May 2014 17:15:23 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Takashi Iwai <tiwai@suse.de>, dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: Atomicity in KMS panic notifier
Message-ID: <20140507171523.48990630@alan.etchedpixels.co.uk>
In-Reply-To: <CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
References: <s5htx94fkfi.wl%tiwai@suse.de>
	<CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Imo trying to fix the current mess and making ->set_config work in
> atomic contexts is pointless. drm_can_sleep is trying to make that
> possible in some ways, and it's horrible since using it means
> busy-loops in atomic contexts outside of panic handlers won't get
> reported any more. Also the interactions with the console_lock (which
> due to some bonghits is protecting almost everything in fbcon/fbdev
> nowadays) would also be almost completely removed.

Unfortunately years ago some Finnish student didn't design his console
driver to be lock friendly and then fbcon/fbdev inherited it.

If you are writing a new console driver please don't use fbcon, use a
text console that writes to a simple n x m text framebuffer with dirty
bits and wakes a waitqueue or work queue of some sort when it changes.
Then just redraw updated bits every vblank frame if its actually changed.

Not only will the lock problems go away it'll blow away the existing
scrolling text performance on any DRM driver except gma500.

Alan
