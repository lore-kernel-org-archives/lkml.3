Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbAEVTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:19:39 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:53656 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbAEVTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:19:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
References: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
	<CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
Date: Mon, 5 Jan 2015 13:19:37 -0800
X-Google-Sender-Auth: yPjG4rS10RgShJzBP67PBrbruyo
Message-ID: <CA+55aFyXOM4TThy3kQsP_ryGU-ECZawXn-z+CZMTWtXBie5aCA@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jay Foad <jay.foad@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# .39.x" <stable@kernel.org>, stable-review@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> IOW, *maybe* a patch like this. TOTALLY UNTESTED! I may have missed
> something, and this may be complete crap.

It does indeed seem to work.

But see my other email about this effectively making the stack limit
one page smaller. I'm not entirely sure it's worth fixing, but maybe
in another four years somebody will post a regression email about that
;)

IOW, I'd be inclined to say "stack limit includes guard page", and
just wait and see whether that causes any issues.

But regardless, I'd like you to test the patch in your environment
(with the full real load, not just the demonstration test case), since
you are clearly doing special things. My limited testing was just that
- very limited.

Thanks,

                                Linus
