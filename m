Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194Ab3FTKQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:16:23 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42639 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935407Ab3FTKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:16:18 -0400
Date: Thu, 20 Jun 2013 12:16:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v14
Message-ID: <20130620101614.GA7322@gmail.com>
References: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
 <20130619124822.GC11209@gmail.com>
 <20130619193855.GY6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619193855.GY6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Ok, this series looks good at first sight: you've slightly overdone the 
> > checkpatch style changes without checking that the result is actually an 
> > improvement - I've fixed those few places.
> > 
> > I'll give it a bit of testing.
> 
> Thanks for testing and merging.
> 
> I still have some other patches to enable other features,
> on top of this.
> 
> I'll repost them in hopefully logical groups. 
> 
> If you want them grouped in some particular way or other
> requirements please let me know.
> 
> https://git.kernel.org/cgit/linux/kernel/git/ak/linux-misc.git/log/?h=hsw/pmu6
> 
> FWIW the outstanding patches do:
> 
> - Some changes to make CPU event aliases more user friendly:
> 
> print aliases in perf list, avoid the need to specify cpu//,
> automatically enable PEBS for mem-loads/stores,
> Allow aliases to specify "precise"
> 
> This is all not Haswell specific, but makes
> the TSX changes below a lot more user friendly.
> 
> Most of this is actually user mode only, except for the
> "precise" alias changes.

Yeah. This I think looks good mostly.

> - TSX changes: perf stat -T, TSX event aliases, support for 
> reporting the abort cause from PEBS, plus the user tools
> support for all of this

Yes.

> - Full width counting (generally useful, but also avoids
> a TSX checkpoint problem)

I'd suggest putting this in first and testing it ASAP, so that any TSX 
patches don't have to worry about it. I'd expect it to just work.

[ You could also now add the patch that standardizes APIC-Ack handling in 
  the NMI handler, removing the Haswell specific quirk. If it causes any 
  problems it's bisectable. ]

> - Support TSX filtering in the the LBR, plus a workaround
> for the duplicated abort record.

Ok.

Please resend all of these on top of latest -tip.

My main and pretty much only complaint regarding the merge process of the 
'basic' Haswell patches in the past few months is that you should try to 
avoid the trivial problems preemptively so that maintainers don't have to 
waste time on dealing with them again and again. Also, when a particular 
category of problem is pointed out try to fix similar instances in other 
pending patches as well - not just strictly the exact problems that have 
been pointed out.

> Plus also on top (not in my git tree):
> 
> - Zheng's call graph lbr mode patches, to allow user mode -g without 
> frame pointers or full dwarf. This has a few known problems, but is 
> still useful enough that it should be available as a option.

This looks useful too, please send these changes in a separate submission 
with all call graph people Cc:-ed: Peter, Frederic, Arnaldo, Jiri, 
Namhyung.

Thanks,

	Ingo
