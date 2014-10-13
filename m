Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaJMTHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:07:45 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:44143 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754326AbaJMTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:07:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12109:12114:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roll00_262bd93f1b036
X-Filterd-Recvd-Size: 2582
Message-ID: <1413227261.1287.14.camel@joe-AO725>
Subject: Re: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix-fix.patch
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Date: Mon, 13 Oct 2014 12:07:41 -0700
In-Reply-To: <20141013185156.GA1959@redhat.com>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
	 <1411464279-20158-1-git-send-email-mhocko@suse.cz>
	 <20140923112848.GA10046@dhcp22.suse.cz> <20140923201204.GB4252@redhat.com>
	 <20141013185156.GA1959@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 14:51 -0400, Dave Jones wrote:
> On Tue, Sep 23, 2014 at 04:12:04PM -0400, Dave Jones wrote:
>  > On Tue, Sep 23, 2014 at 01:28:48PM +0200, Michal Hocko wrote:
>  >  > And there is another one hitting during randconfig. The patch makes my
>  >  > eyes bleed but I don't know about other way without breaking out the
>  >  > thing into separate parts sounds worse because we can mix with other
>  >  > messages then.
>  > 
>  > how about something along the lines of..
>  > 
>  >  bufptr = buffer = kmalloc()
[]
>  > It does introduce an allocation though, which may be problematic
>  > in this situation. Depending how big this gets, perhaps make it static
>  > instead?
> 
> Now that this landed in Linus tree, I took another stab at it.
> Something like this ? (Untested beyond compiling).
> 
> (The diff doesn't really do it justice, it looks a lot easier to read
>  imo after applying).
> 
> There's still some checkpatch style nits, but this should be a lot
> more maintainable assuming it works.
> 
> My one open question is do we care that this isn't reentrant ?
> Do we expect parallel calls to dump_mm from multiple cpus ever ?


> diff --git a/mm/debug.c b/mm/debug.c
[]
> @@ -164,74 +164,85 @@ void dump_vma(const struct vm_area_struct *vma)
>  }
>  EXPORT_SYMBOL(dump_vma);
>  
> +static char dumpmm_buffer[4096];

Given the maximum single printk is 1024 bytes,
a buffer larger than that 1024 bytes is useless.

grep LOG_LINE_MAX


