Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaJUQJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:09:05 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40591 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaJUQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <s5hbnp5z9uy.wl-tiwai@suse.de>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
	<cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
	<543FB374.8020604@metafoo.de>
	<543FC3CD.8050805@osg.samsung.com>
	<s5h38aow1ub.wl-tiwai@suse.de>
	<543FD1EC.5010206@osg.samsung.com>
	<s5hy4sgumjo.wl-tiwai@suse.de>
	<543FD892.6010209@osg.samsung.com>
	<s5htx34ul3w.wl-tiwai@suse.de>
	<54467EFB.7050800@xs4all.nl>
	<s5hbnp5z9uy.wl-tiwai@suse.de>
Date: Tue, 21 Oct 2014 12:08:59 -0400
Message-ID: <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Shuah Khan <shuahkh@osg.samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antti Palosaari <crope@iki.fi>, "olebowle@gmx.com" <olebowle@gmx.com>,
        "ramakrmu@cisco.com" <ramakrmu@cisco.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>, perex@perex.cz,
        prabhakar.csengg@gmail.com, Tim Gardner <tim.gardner@canonical.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I'm not convinced by that.  If the device has to be controlled
> exclusively, the right position is the open/close.  Otherwise, the
> program cannot know when it becomes inaccessible out of sudden during
> its operation.

I can say that I've definitely seen cases where if you configure a
device as the "default" capture device in PulseAudio, then pulse will
continue to capture from it even if you're not actively capturing the
audio from pulse.  I only spotted this because I had a USB analyzer on
the device and was dumbfounded when the ISOC packets kept arriving
even after I had closed VLC.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
