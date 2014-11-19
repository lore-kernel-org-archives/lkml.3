Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbaKSXJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:09:04 -0500
Received: from mout2.fh-giessen.de ([212.201.18.46]:47464 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:09:03 -0500
Message-ID: <546D2309.90201@mni.thm.de>
Date: Thu, 20 Nov 2014 00:08:57 +0100
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
> ...
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
> ...

Added the above on top of your "fixed-fences-for-bisect" branch and 
guessed it would work, but did not :/
Anyway, as this "initializes" the fence to a known state, maybe you 
should consider pushing that.

Going to compile the kernel with trace events (lets see how) ...

Tobias
