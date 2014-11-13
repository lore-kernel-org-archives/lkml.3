Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaKMTpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:45:32 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:56591 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:45:30 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <5464EC7A.7050603@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
 <1410553499-55951-5-git-send-email-s-anna@ti.com> <CAK=WgbamdqAufjC4Xb5moERRBSB-cO6c1RPTE=f+dp75F+Eh7A@mail.gmail.com>
 <5463B5B6.8040709@ti.com> <CAK=WgbbatPTiz3efDWHVEcuug_UQfkCViMoK0zcfUg3JwB2oTA@mail.gmail.com>
 <5464EC7A.7050603@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 13 Nov 2014 21:45:09 +0200
Message-ID: <CAK=WgbbodS8GsUxQbkyCp6hAG+Ko4LMirx+pUa8_fUdxWFasvw@mail.gmail.com>
Subject: Re: [PATCHv6 4/5] hwspinlock/core: add common OF helpers
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, Nov 13, 2014 at 7:38 PM, Suman Anna <s-anna@ti.com> wrote:
> No, not always, because, either of them can be optional between
> different platform implementations. For example, on OMAP, the number of
> locks is read from an IP register, and not coded in DT. Similarly,
> base_id can be optional on SoCs that don't have multiple IP instances.

It can, but base_id isn't optional today --- it must be provided via
platform_data --- and I'm not sure we should implicitly change this
semantics while moving to DT. We never guessed the base_id before,
even if there was only a single IP instance, and I'm not convinced we
should start doing it now.

About the number of locks - why do we even need it at this point? the
global lock id should just be base_id + the lock index.

> IMHO, this life cycle management is not that complicated

It's always very easy to add code, really. It is never complicated.
But then gradually the code becomes harder to maintain, debug, and
change.

On the contrary, achieving the same functionality with less code is
always harder. But when we get there, the results are pretty
satisfying.

In this case I still feel the extra linked list is redundant.

Please try it: ditch the "hwspinlock/core: maintain a list of
registered hwspinlock banks" patch, and replace of_hwspin_lock_get_id
with a slim method that just returns the base_id + the lock index. Let
me know if it works for you.

Thanks,
Ohad.
