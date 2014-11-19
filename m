Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaKSP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:29:50 -0500
Received: from mout1.fh-giessen.de ([212.201.18.42]:50108 "EHLO
	mout1.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaKSP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:29:47 -0500
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 10:29:47 EST
Message-ID: <546CB4E2.3010707@mni.thm.de>
Date: Wed, 19 Nov 2014 16:18:58 +0100
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:36.0) Gecko/20100101 Thunderbird/36.0a1
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Michael Marineau <mike@marineau.org>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: 3.18-rc regression: drm/nouveau: use shared fences for
 readable objects
References: <CAHW-aUcEipi+NeU3wapLABV41Sud7Qy_=EYXCei9Dmf18SxuZA@mail.gmail.com> <546C5085.1020300@canonical.com>
In-Reply-To: <546C5085.1020300@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.11.2014 09:10, Maarten Lankhorst wrote:
> Hey,
>
> On 19-11-14 07:43, Michael Marineau wrote:
>> On 3.18-rc kernel's I have been intermittently experiencing GPU
>> lockups shortly after startup, accompanied with one or both of the
>> following errors:
>>
>> nouveau E[   PFIFO][0000:01:00.0] read fault at 0x000734a000 [PTE]
>> from PBDMA0/HOST_CPU on channel 0x007faa3000 [unknown]
>> nouveau E[     DRM] GPU lockup - switching to software fbcon
>>
>> I was able to trace the issue with bisect to commit
>> 809e9447b92ffe1346b2d6ec390e212d5307f61c "drm/nouveau: use shared
>> fences for readable objects". The lockups appear to have cleared up
>> since reverting that and a few related followup commits:
>>
>> 809e9447: "drm/nouveau: use shared fences for readable objects"
>> 055dffdf: "drm/nouveau: bump driver patchlevel to 1.2.1"
>> e3be4c23: "drm/nouveau: specify if interruptible wait is desired in
>> nouveau_fence_sync"
>> 15a996bb: "drm/nouveau: assign fence_chan->name correctly"
> Weird. I'm not sure yet what causes it.
>
> http://cgit.freedesktop.org/~mlankhorst/linux/commit/?h=fixed-fences-for-bisect&id=86be4f216bbb9ea3339843a5658d4c21162c7ee2
>
> On the EDITED patch from fixed-fences-for-bisect, can you do the following:
>
> In nouveau/nv84_fence.c function nv84_fence_context_new, remove
>
> fctx->base.sequence = nv84_fence_read(chan);
>
> and add back
>
> nouveau_bo_wr32(priv->bo, chan->chid * 16/4, 0x00000000);
>
> If that fails you should compile your kernel with trace events, to get some debugging info from the fences. I'll post debugging info if this does not fix it.
>
> ~Maarten

Hey,
as mentioned in IRC the new fencing hangs my GPU for a while as well (nve7).
Bisected back to  86be4f216bbb9ea3339843a5658d4c21162c7ee2
, EDITED

from the fixed-fences-for-bisect branch mentioned above.

Original bisect on linus brach brought me to:
29ba89b2371d466ca68973525816cf10debc2655
drm/nouveau: rework to new fence interface

Michael if you are going to bisect the "fixed-fences-for-bisect" branch, 
maybe take a closer look if you come anywhere near that commit, if that 
does or does not trigger the GPU hangs for you!

Tobias
