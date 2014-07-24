Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbaGXQ31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:29:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59301 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397AbaGXQ30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:29:26 -0400
Date: Thu, 24 Jul 2014 18:29:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724162921.GO19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
 <20140724113726.GL19239@pd.tnic>
 <20140724133059.GA32421@khazad-dum.debian.net>
 <20140724142802.GN19239@pd.tnic>
 <20140724150740.GD32421@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140724150740.GD32421@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:07:40PM -0300, Henrique de Moraes Holschuh wrote:
> Suppose you have a box that takes ldrver 1 microcode, and Intel
> releases microcode for a new type of core that has a ldrver of 2, and
> it happens to not be the last one in the microcode collection sent by
> userspace (via the early initrd or /dev/cpu/microcode). We might well
> abort before we find the correct microcode update for that box.

And? The ldrver 2 header will enter microcode_sanity_check() and abort
there. A bit later. Same deal.

If you want to *skip* over ldrver 2 ucode headers but continue looping
over the ucode data, then you need to do more than that.

So what exactly are you trying to fix here?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
