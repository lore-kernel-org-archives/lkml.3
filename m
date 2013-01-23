Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3AWQtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:49:09 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50892 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3AWQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:49:07 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <s5hk3r3etwt.wl%tiwai@suse.de>
References: <1358958309-5342-1-git-send-email-daniel.vetter@ffwll.ch>
	<1358958309-5342-2-git-send-email-daniel.vetter@ffwll.ch>
	<s5hk3r3etwt.wl%tiwai@suse.de>
Date: Wed, 23 Jan 2013 17:49:04 +0100
Message-ID: <CAKMK7uG-c3-qaMToTxYR+eeTD_NF7uJ2T76oemfb9r+zPcpz=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] fb: Rework locking to fix lock ordering on takeover
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fbdev-devel@lists.sourceforge.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 5:38 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 23 Jan 2013 17:25:08 +0100,
> Daniel Vetter wrote:
>>
>> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>
>> Adjust the console layer to allow a take over call where the caller already
>> holds the locks. Make the fb layer lock in order.
>>
>> This s partly a band aid, the fb layer is terminally confused about the
>> locking rules it uses for its notifiers it seems.
>>
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> [danvet: Tiny whitespace cleanup.]
>> Reported-and-tested-by: Hugh Dickins <hughd@google.com>
>> Reported-and-tested-by: Sasha Levin <levinsasha928@gmail.com>
>> References: https://lkml.org/lkml/2012/10/25/516
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> FYI, the latest patch of this is found in mm tree:
>   http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
>
> Also I hit the same problem in another code paths (for unbind and
> unregister):
>   http://marc.info/?t=135309396400003&r=1&w=2
>
> My additional patch is found in mm tree, too:
>   http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

Indeed, there's more stuff :( And I've missed the export_symbol fix
for the first patch. Still, is there any chance we can at least merge
the first one (I don't think that many people unload framebuffers)
into 3.8 with cc: stable? I'd like to get at least rid of the known
deadlocks at kms takeover time, since we have quite a few unexplained
such bug reports floating around ... Andrew, Dave?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
