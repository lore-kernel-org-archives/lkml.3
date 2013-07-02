Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3GBSoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:44:13 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:40527 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3GBSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:44:12 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Alex Deucher'" <alexdeucher@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <004101ce7752$989eca50$c9dc5ef0$@lucidpixels.com> <CADnq5_ODTumYOq19BMuF6vJNq+RtUA631XqyUet4qzjVU1tg-Q@mail.gmail.com>
In-Reply-To: <CADnq5_ODTumYOq19BMuF6vJNq+RtUA631XqyUet4qzjVU1tg-Q@mail.gmail.com>
Subject: RE: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).
Date: Tue, 2 Jul 2013 14:44:12 -0400
Message-ID: <004501ce7754$25c5a0b0$7150e210$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFkFOgVTW22lyUAF1qnlUWJ13YHdgLJO3WMmhAzNJA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Alex Deucher [mailto:alexdeucher@gmail.com] 
Sent: Tuesday, July 02, 2013 2:36 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; dri-devel@lists.freedesktop.org
Subject: Re: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error
initializing UVD (-1).

> The screen goes black for ~5 seconds and then come back on.
> Not sure if this has been reported or not (w/CEDAR chipset) but FYI.

Make sure you have the the latest CEDAR_rlc.bin in addition to
CYPRESS_uvd.bin and make sure the latest images are available in your
initrd or kernel image, etc.

Alex

--

Hi,

Even with the latest (confirmed below) and built-in to the kernel:

$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
Cloning into 'linux-firmware'...
remote: Counting objects: 2210, done.
remote: Compressing objects: 100% (1102/1102), done.
remote: Total 2210 (delta 1123), reused 2113 (delta 1073)
Receiving objects: 100% (2210/2210), 39.84 MiB | 6.49 MiB/s, done.
Resolving deltas: 100% (1123/1123), done.
$ date
Tue Jul  2 14:39:19 EDT 2013

2b244d41832f46382bfbb8994522dcdd  d/linux-firmware/radeon/CEDAR_me.bin
23915e382ea0d2f2491a19146ca3001c  d/linux-firmware/radeon/CEDAR_pfp.bin
e8770d3d588f24dc6f1a8609c9db3467  d/linux-firmware/radeon/CEDAR_rlc.bin
fb23b281dcc94a035d374e709c9842bd  d/linux-firmware/radeon/CYPRESS_uvd.bin

Current system firmware (/lib/firmware/radeon):
$ for i in $CONFIG_EXTRA_FIRMWARE; do md5sum $i; done
2b244d41832f46382bfbb8994522dcdd  radeon/CEDAR_me.bin
23915e382ea0d2f2491a19146ca3001c  radeon/CEDAR_pfp.bin
e8770d3d588f24dc6f1a8609c9db3467  radeon/CEDAR_rlc.bin
fb23b281dcc94a035d374e709c9842bd  radeon/CYPRESS_uvd.bin

CONFIG_EXTRA_FIRMWARE="radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
radeon/CEDAR_rlc.bin radeon/CYPRESS_uvd.bin"

Same issue.

Justin.

