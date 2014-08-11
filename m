Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaHKTGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:06:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35650 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaHKTGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:06:48 -0400
Date: Mon, 11 Aug 2014 12:06:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: nand: Use ULL-suffix for big u64 constant
Message-ID: <20140811190644.GA3711@ld-irv-0074>
References: <1407604073-7484-1-git-send-email-geert@linux-m68k.org>
 <20140811175036.GU3711@ld-irv-0074>
 <CAMuHMdUNoD5qFhfVP2jJvgqPi=c6xe6YAbmQWYt_ir7rtqp_OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUNoD5qFhfVP2jJvgqPi=c6xe6YAbmQWYt_ir7rtqp_OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 08:51:51PM +0200, Geert Uytterhoeven wrote:
> On Mon, Aug 11, 2014 at 7:50 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
> > On Sat, Aug 09, 2014 at 07:07:53PM +0200, Geert Uytterhoeven wrote:
> >> drivers/mtd/nand/nand_timings.c:45: warning: integer constant is too large for ‘long’ type
> >
> > On what compiler / static analyzer?
> 
> Any 32-bit version of gcc at the standard warning level, at least
> until gcc 4.4.7.
> With gcc 4.6 it's indeed gone.
> 
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> ---
> >>  drivers/mtd/nand/nand_timings.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
> >> index 8b36253420fa..e81470a8ac67 100644
> >> --- a/drivers/mtd/nand/nand_timings.c
> >> +++ b/drivers/mtd/nand/nand_timings.c
> >> @@ -42,7 +42,7 @@ static const struct nand_sdr_timings onfi_sdr_timings[] = {
> >>               .tRHZ_max = 200000,
> >>               .tRLOH_min = 0,
> >>               .tRP_min = 50000,
> >> -             .tRST_max = 250000000000,
> >> +             .tRST_max = 250000000000ULL,
> >
> > See [1] and [2]. I'm pretty sure it is a bug in your tool to warn about
> 
> Yes, I saw those, after I had created my patch. I decided to send it anyway ;-)
> 
> > this. The C standard seems pretty clear that the large literal constant
> > is automatically promoted to a sufficiently large type, so AIUI there
> > should be no need for such a warning. A standards-compliant compiler
> > will do the right thing.
> 
> Actually I didn't know there existed versions of gcc that did _not_ give
> this warning. This seems to be a recent thing on gcc for 32-bit targets.
> For 64-bit targets, apparently it only gives a warning if the constant
> is that large that it can no longer fit in a 64-bit signed integer.

I'm curious: do your broken compilers also generate broken code/data?
i.e., does gcc 4.4.7 give 250000000000 its proper ULL value still?

> > However, I could be convinced to apply this, if only to satisfy broken
> > tools and to avoid addressing this question over and over...
> 
> So please apply. Too many people are still using 32-bit targets and
> gcc < 4.6.

OK, you've convinced me ;) Applied to l2-mtd.git/next, with an editorial
comment.

Brian
