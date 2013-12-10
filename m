Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3LJLAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:00:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38398 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312091427370.17848@chino.kir.corp.google.com>
References: <10123265.xdzIJ6I9nc@hex>
	<alpine.DEB.2.02.1312091427370.17848@chino.kir.corp.google.com>
Date: Tue, 10 Dec 2013 22:00:07 +1100
X-Google-Sender-Auth: UFkpLQXhHbGrFgcxfOidMmI5on8
Message-ID: <CABqErrFyb++8g6PcFOhoOw22+mTCOrnGPuSMPdfBdP=nNnzW8A@mail.gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler v0.444 for linux-3.12
From: Con Kolivas <kernel@kolivas.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2013 09:30, David Rientjes <rientjes@google.com> wrote:
> Any reason that BFS hardcodes CONFIG_SLUB as the only slab allocator
> allowed?  I've cc'd Pekka and Christoph and I'm sure they'd be interested
> in any reasons that CONFIG_SLAB doesn't work correctly with a different
> drop-in scheduler, or is it just that interactivity has tested better with
> slub?

Hi David.

Thanks, and an interesting question you have there.

To be honest it's been probably over 2 years since I hard coded SLUB
into the BFS patch and all I can recall is that it caused a crash that
was purely due to enabling SLAB that went away with SLUB when used
with BFS. Despite the possibility that BFS exposes an issue in the
kernel that may be possible with the mainline scheduler (due to BFS
being extremely good at exposing race conditions), if the problem is
never reported with mainline, it's probably of no significance to
mainline. Changes in scheduler initialisation sequence alone may be
the real reason. The same goes with the offline CPU code which had to
be drastically reworked to work properly with suspend/hibernate on
BFS.

There certainly have been cases that BFS has exposed races that have
only become apparent in mainline a long time later. Here's one I
recall reporting as a potential issue a long time ago here:
http://marc.info/?l=linux-kernel&m=130613435113919&w=2
It was instantly discounted as not a problem, yet about 6 months later
a real issue in this code showed up.

I have no idea if the CONFIG_SLAB problem falls into this category.

Regards,
Con
