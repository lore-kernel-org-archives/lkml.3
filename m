Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaJFSl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:41:57 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46451 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJFSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:41:54 -0400
Date: Mon, 6 Oct 2014 20:41:50 +0200
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Workable vintage driver support mechanism? (Re: [alsa-devel] [PATCH
 v3] ES938 support for ES18xx driver)
Message-ID: <20141006184150.GA2465@rhlx01.hs-esslingen.de>
References: <1412027079-15876-1-git-send-email-linux@rainbow-software.org>
 <s5h7g0dzgd5.wl-tiwai@suse.de>
 <201410061555.19007.linux@rainbow-software.org>
 <s5ha959xp53.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5ha959xp53.wl-tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 04:13:12PM +0200, Takashi Iwai wrote:
> At Mon, 6 Oct 2014 15:55:18 +0200,
> Ondrej Zary wrote:
> > ES938 does not depend on ES18xx and can be connected to any device with MIDI 
> > interface. Maybe there are some other cards with this chip.
> 
> Please prove it :)

:(

> That said, I'm not willing to merge the patch in the current form.
> One of the reason is that this can be implemented pretty easily in
> user-space.  Another is that it's a deadly old device, and likely only
> handful boards are still running in the world, thus no much motivation
> to bloat the kernel code for that.  We're even discussing to get rid
> of ISA codes from the kernel tree nowadays.
> 
> Sorry, the patch was submitted 10 years too late.

:((

Given that I hate the forces that are increasingly coming into play here
(but of course I do see the bigger picture, namely of kernel tree bloat),
I think I have an idea which might be useful to accept:
for every piece of sufficiently "vintage" submission,
people would be tasked with offering (or somehow ensuring)
a sufficiently closely time-related cleanup in other places.

Thus, given a "diffstat penalty" (lines added minus lines removed)
of the vintage support patch:

Additionally offer a cleanup patch
which gets rid of redundantly implemented kernel tree functionality:
- for 15 year old devices: 0.5 * diffstat_penalty
- for 20 year old devices: 1.0 * diffstat_penalty
- for 25 year old devices: 1.5 * diffstat_penalty
- for 30 year old devices: whaaa?

Hmm?

Andreas Mohr
