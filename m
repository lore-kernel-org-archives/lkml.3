Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaJWJ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:56:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbaJWJ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:56:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Wilck, Martin" <martin.wilck@ts.fujitsu.com>
Cc: "minyard@acm.org" <minyard@acm.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if ipmi_msghandler gets loaded
Date: Thu, 23 Oct 2014 11:56:26 +0200
Message-ID: <2294896.XUUpIPFQ25@d46>
User-Agent: KMail/4.11.5 (Linux/3.11.10-11-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413793733.2678.10.camel@pdbcooper.pdb.fsc.net>
References: <20141014144020.683892494@d46.suse.de> <54414057.5020806@acm.org> <1413793733.2678.10.camel@pdbcooper.pdb.fsc.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 10:28:53 AM Wilck, Martin wrote:
> On Fri, 2014-10-17 at 18:14 +0200, Corey Minyard wrote:
> 
> 
> > How about this.  I did a little research, and there's something called
> > soft module dependencies.  Apparently you can add:
> > 
> > MODULE_SOFTDEP("post: ipmi_devintf")
> > 
> > to ipmi_msghandler.c and modprobe would load ipmi_devintf after loading
> > ipmi_msghandler if it was available.

I do not like this approach for 2 reasons:
1) Same as Martin mentioned: Not avail on all distros yet (not double checked,
   but I trust you).
2) It's still wrong or say, far away from being as it should be:
   Instead of autoloading via userspace (this is what I expect happens here),
   ipmi_devintf should directly be compiled into ipmi_msghandler module
   and be available as soon as ipmi_msghandler is available.
   This saves the overhead of an unneeded additional module
   (memory and loading time overhead -> going through userspace, etc.).

> This is nice, but not commonly available in distro kernels so far.
Sorry, it's not that nice...
> AFAICS, out of the distros Fujitsu supports, only RHEL7 supports it.
Bad.
 
> I vote for MODULE_SOFTDEP for upstream, and modalias for distros that
> don't support MODULE_SOFTDEP yet.
I vote for ipmi_msghandler.c renaming into ipmi_handler.c
I looked around a bit. Renaming is not bad and happens often.
Documentation/laptops/hpfall.c
got renamed into:
Documentation/laptops/freefall.c
history is preserved by using:
git log --follow Documentation/laptops/freefall.c
git blame Documentation/laptops/freefall.c
works as well, showing modifications before the renaming.

I'll send a patchset.

Thanks,

   Thomas
