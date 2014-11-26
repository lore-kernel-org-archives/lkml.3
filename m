Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaKZNzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:55:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaKZNzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:55:10 -0500
Date: Wed, 26 Nov 2014 14:55:08 +0100
From: Michal Marek <mmarek@suse.cz>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: collect shorthands into scripts/Kbuild.include
Message-ID: <20141126135508.GA6911@sepie.suse.cz>
References: <1416997873-3872-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416997873-3872-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 07:31:13PM +0900, Masahiro Yamada wrote:
> The shorthand "clean" is defined in both the top Makefile and
> scripts/Makefile.clean.  Likewise, the "hdr-inst" is defined in
> both the top Makefile and scripts/Makefile.headersinst.
> 
> To reduce code duplication, this commit collects them into
> scripts/Kbuild.include like the "build" and "modbuiltin" shorthands.
> It requires scripts/Makefile.clean to include scripts/Kbuild.include,
> but its impact on the performance of "make clean" should be
> negligible.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
> 
> Marek, please decide if this patch should be applied or not.
> 
> I am not so sure if 10% of performance regression is acceptable.
> I do not mind at all if this patch is rejected.
> 
> Before this commit, on my box,
> 
> $ time make clean
> 
> real	0m2.916s
> user	0m1.040s
> sys	0m2.005s
> 
> After,
> 
> real	0m3.221s
> user	0m1.109s
> sys	0m2.271s

0.3s is even less than my guess. And as I said, you can run make clean
in parallel, so I'm not thrilled. Applied to kbuild.git#kbuild.

Thanks,
Michal
