Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IVVu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:50:56 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:11499 "EHLO
	fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752137Ab3IVVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:50:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=87.106.93.118;
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Sun, 22 Sep 2013 22:50:48 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Richter <thor@math.tu-berlin.de>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] i835GM flicker on panning
Message-ID: <20130922215048.GA6986@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Thomas Richter <thor@math.tu-berlin.de>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
 <alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
 <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
 <523F2390.5030702@math.tu-berlin.de>
 <CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
X-To-Not-Matched: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 10:03:21PM +0200, Daniel Vetter wrote:
> Hm, that sounds a bit more like the ddx is having fun with rendering.
> Have you tried switching the backed from to either SNA or UXA? Also
> adding relevant mailing lists ...

If it was just the ddx, you would observe the same tearing with the
rotated setup as well. The question here would be whether it is tearing
or flicker?  Tearing would just be the usual frontbuffer rendering
artifact. However,  flicker could be misrendering of a DRI client (seeing
the backbuffer etc) or a clock timing issue (pipe underruns and whatnot).
Using a rotated framebuffer would disable pageflipping, and prevent the
historically common glitches when flipping. (Historically? That's
hysterical!)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
