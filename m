Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaDHCE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:04:28 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54150 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbaDHCE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com>
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me>
 <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 7 Apr 2014 21:56:41 -0400
Message-ID: <CAOPLpQc8R2SfTB+=BsMa09tcQ-iBNJHg+tGnPK-9EDH1M47MJw@mail.gmail.com>
Subject: Re: NUMA node information for pages
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, xemul@parallels.com,
        rientjes@google.com, paul.gortmaker@windriver.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 9:24 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> The information about "pfn-node" mapping seldom (or never) changes after boot,
> so it seems better to me that adding a new interface somewhere under
> /sys/devices/system/node/nodeN which shows pfn range of a given node.
> If this doesn't work for your usecase, could you explain more about how you
> use this information?

I have no problem with that type of interface.  It'll be more work
figuring out the details since the interface I proposed is trivial and
mimics that of kpageflags etc but that's manageable.

I'll see whether I can figure out the necessary details.  I imagine
that if the PFN are indeed always clustered for each node then, as
David proposes, text output like

  PFNSTART PFNSTOP

in a file below /sys/devices/system/node/nodeN should be sufficient.

How does memory hot plug work in this situation?  If the PFNs are
allocated dense at startup then there might potentially be many ranges
for each node.
