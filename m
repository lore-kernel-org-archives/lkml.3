Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbaGXRtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:49:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55920 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933922AbaGXRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:49:45 -0400
X-Sasl-enc: s+YUV4r+bcVs/pIEAKNPYJhocmSYqbopKQetGiDFKFYT 1406224183
Date: Thu, 24 Jul 2014 14:49:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724174931.GC12180@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
 <20140724113726.GL19239@pd.tnic>
 <20140724133059.GA32421@khazad-dum.debian.net>
 <20140724142802.GN19239@pd.tnic>
 <20140724150740.GD32421@khazad-dum.debian.net>
 <20140724162921.GO19239@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724162921.GO19239@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Borislav Petkov wrote:
> On Thu, Jul 24, 2014 at 12:07:40PM -0300, Henrique de Moraes Holschuh wrote:
> > Suppose you have a box that takes ldrver 1 microcode, and Intel
> > releases microcode for a new type of core that has a ldrver of 2, and
> > it happens to not be the last one in the microcode collection sent by
> > userspace (via the early initrd or /dev/cpu/microcode). We might well
> > abort before we find the correct microcode update for that box.
> 
> And? The ldrver 2 header will enter microcode_sanity_check() and abort
> there. A bit later. Same deal.
> 
> If you want to *skip* over ldrver 2 ucode headers but continue looping
> over the ucode data, then you need to do more than that.

Now that I noticed that ldrver problem exists, I want to do that as well,
but that was _not_ the purpose of this patch and it should be done as a
separate change anyway.

> So what exactly are you trying to fix here?

I want to stop accessing fields inside an unknown format of microcode
header.

I didn't notice I could remove the test inside microcode_sanity_check(),
just that it was in the wrong place.  However, even if I had noticed it was
a duplicate, I would have not removed it: IMHO, moving it up a bit like
this patch did makes that duplicate test useful as documentation, and it is
true to the intent of the function.

I will respin this patch using the helpers you proposed, and add a new one
enhancing the way we deal with ldrver.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
