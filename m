Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaDVTRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:17:12 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:49982 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaDVTRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140422184518.GC3528@book.gsilab.sittig.org>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
	<1398175396-7560-2-git-send-email-grmoore@altera.com>
	<20140422184518.GC3528@book.gsilab.sittig.org>
Date: Tue, 22 Apr 2014 14:17:05 -0500
Message-ID: <CA+iBjpS2UAPk+TiuX7_Ufp6uXwU3nxFZ-8emwGU2TMF9+6q66g@mail.gmail.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
From: Graham Moore <ggrahammoore@gmail.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: Graham Moore <grmoore@altera.com>, ZY - marex <marex@denx.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:45 PM, Gerhard Sittig <gsi@denx.de> wrote:
> the patch appears to not have dev_err() references, were they
> removed? see below
[...]
> this emits a message that an error has occured, but doesn't tell
> where it occured -- can you dev_err() here to make the message
> even more helpful?

Yeah, the previous dev_err was actually copy-pasted from a similar
function that already existed.  When I rebased to l2-mtd/spinor, I did
the same copy-paste but that branch has pr_err instead of dev_err.
I'm a noob, so I didn't want to change things without a good
explanation :)  On the other hand, I'm in favor of using dev_err
instead.

[...]
> this logic always returns "timed out" when the ready flag is not
> seen, even in the case of read errors -- can you "preset" the
> error code with "timed out", and update it with something more
> appropriate before returning when other errors are seen?
>
> though this is an internal helper, and callers may not tell the
> situations apart in the first place, so this might be a minor nit

Same here as above, copy-pasted, and so the logic is what already
existed.  I double-checked the calling code, and like you say, the
callers do not tell the situations apart.  About half the calls assume
any error is timeout.  The others either pass return value or some
other error up, or they ignore it.

Thanks,
Graham
