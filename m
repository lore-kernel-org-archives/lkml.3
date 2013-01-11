Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3AKHrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:47:36 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40383
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab3AKHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:47:32 -0500
Message-ID: <50EFC38D.80306@kernel.dk>
Date: Fri, 11 Jan 2013 08:47:25 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Eldad Zack <eldad@fogrefinery.com>, perex@perex.cz,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oops in sound/usb/pcm.c:match_endpoint_audioformats() in current
 -git
References: <50EE7A94.60409@kernel.dk> <s5hobgx72zf.wl%tiwai@suse.de> <50EEB8D2.2030702@kernel.dk> <s5hsj696tgw.wl%tiwai@suse.de> <alpine.LNX.2.00.1301102038560.1321@xoschi> <s5hehhskcya.wl%tiwai@suse.de>
In-Reply-To: <s5hehhskcya.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-10 21:19, Takashi Iwai wrote:
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH v2] ALSA: usb-audio: Fix NULL dereference by access to
>  non-existing substream
> 
> The commit [0d9741c0: ALSA: usb-audio: sync ep init fix for
> audioformat mismatch] introduced the correction of parameters to be
> set for sync EP.  But since the new code assumes that the sync EP is
> always paired with the data EP of another direction, it triggers Oops
> when a device only with a single direction is used.
> 
> This patch adds a proper check of sync EP type and the presence of the
> paired substream for avoiding the crash.
> 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Confirmed, it works. You can add my tested-by too. Thanks Takashi!

-- 
Jens Axboe

