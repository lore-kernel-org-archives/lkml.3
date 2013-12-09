Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527Ab3LIVNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:13:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3LIVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:13:49 -0500
Date: Mon, 9 Dec 2013 22:13:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
In-Reply-To: <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com> <alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz> <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, H.J. Lu wrote:

> >> Normally, a PIE executable has zero virtual address on the first PT_LOAD
> >> segment and kernel will load such executable at random address when
> >> randomization is enabled.  If randomization is disabled, kernel will load
> >> it at a fixed address.  But if a PIE executable has non-zero virtual
> >> address on the first PT_LOAD segment, kernel will load such executable
> >> at the non-zero virtual address when randomization is enabled. But when
> >> randomization is disabled, kernel ignores the non-zero virtual address
> >> at the non-zero virtual address when randomization is enabled.
> >
> > Hmm ... isn't actually this the thing that needs to be fixed instead?
> >
> > IOW, when randomization is enabled, is there a reason not to load on
> > randomized address? (even if the first PT_LOAD segment has non-zero
> > vaddr?)
> 
> No, please don't do that.  Normally, PIE has zero load address and kernel
> can load it anywhere.  There are multiple reasons why PIE has non-zero
> load address.  Saying you need to load a program above 4GB under x86-64,
> you can't do that with normal dynamic executable.  PIE with non-zero load
> address is the only way to do that on x86-64.

Hmm, so if it's because of 4G PT_LOAD limit, how about at least adding 
randomized offset to the supplied vaddr?

PT_LOAD being non-zero causing randomization to be turned off seems like 
quite unexpected behavior to me, with a great potential to cause a lot of 
confusion.

-- 
Jiri Kosina
SUSE Labs
