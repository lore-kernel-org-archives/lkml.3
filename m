Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaIJHuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:50:10 -0400
Received: from sym2.noone.org ([178.63.92.236]:41777 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaIJHuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:50:05 -0400
Date: Wed, 10 Sep 2014 09:49:59 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Chung-Lin Tang <chunglin_tang@mentor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Valdis.Kletnieks@vt.edu,
        Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v3 25/29] nios2: Module support
Message-ID: <20140910074959.GA14260@distanz.ch>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
 <1410168160-3624-26-git-send-email-lftan@altera.com>
 <75377.1410297958@turing-police.cc.vt.edu>
 <540FFDD5.8000403@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540FFDD5.8000403@mentor.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 at 09:29:25 +0200, Chung-Lin Tang <chunglin_tang@mentor.com> wrote:
> On 14/9/10 5:25 AM, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 08 Sep 2014 17:22:36 +0800, Ley Foon Tan said:
> >> This patch adds support for loadable modules.
> >>
> >> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> > 
> >> +/*
> >> + * Modules should NOT be allocated with kmalloc for (obvious) reasons.
> >> + * But we do it for now to avoid relocation issues. CALL26/PCREL26 cannot reach
> >> + * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc returns
> >> + * addresses in 0xc0000000)
> >> + */
> > 
> > That's a nice scary comment to see. :)
> > 
> > What's the long-term plan here?
> > 
> 
> We would probably need to add the ability to add trampolines in some
> way, though this of course impairs a little performance. Or if the
> default region of vmalloc can be configured to use the same 256MB region
> as the kernel.
> 
> I wonder how MIPS (which has similar same-region call/jump instructions)
> deals with this?

Please see Arnd's comment on the v2 of this patch [1] for a solution.

[1] http://www.spinics.net/lists/linux-arch/msg27059.html
