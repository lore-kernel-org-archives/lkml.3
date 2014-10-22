Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaJVTpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:45:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:61718 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaJVTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <544804F1.7090606@linux.intel.com>
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
	<CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
	<544804F1.7090606@linux.intel.com>
Date: Wed, 22 Oct 2014 15:45:42 -0400
Message-ID: <CAGoCfiyQVY6Ss2qcp3aQijq3cP3BAM8X4yaCXRtx63dNNm-QKA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "ramakrmu@cisco.com" <ramakrmu@cisco.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this seems like a feature, not a bug. PulseAudio starts streaming before
> clients push any data and likewise keeps sources active even after for some
> time after clients stop recording. Closing VLC in your example doesn't
> immediately close the ALSA device. look for module-suspend-on-idle in your
> default.pa config file.

The ALSA userland emulation in PulseAudio is supposed to faithfully emulate
the behavior of the ALSA kernel ABI... except when it doesn't, then it's not
a bug but rather a feature.  :-)

> I also agree that the open/close of the alsa device is the only way to
> control exclusion.

I was also a proponent that we should have fairly coarse locking done
at open/close for the various device nodes (ALSA/V4L/DVB).  The challenge here
is that we have a large installed based of existing applications that
rely on kernel
behavior that isn't formally specified in any specification.  Hence
we're forced to try
to come up with a solution that minimizes the risk of ABI breakage.

If we were doing this from scratch then we could lay down some hard/fast rules
about things apps aren't supposed to do and how apps are supposed to respond
to those exception cases.  Unfortunately we don't have that luxury here.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
