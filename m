Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbaCDVAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:00:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:56352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbaCDVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:00:34 -0500
Date: Tue, 4 Mar 2014 13:00:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk,
        vgupta@synopsys.com, catalin.marinas@arm.com, will.deacon@arm.com,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, vapier@gentoo.org,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, rkuo@codeaurora.org,
        tony.luck@intel.com, fenghua.yu@intel.com, takata@linux-m32r.org,
        geert@linux-m68k.org, james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        tj@kernel.org, hch@infradead.org
Subject: Re: [PATCH 28/44] Add translate_signal() helper
Message-ID: <20140304210010.GA6464@infradead.org>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
 <1393804758-7916-6-git-send-email-richard@nod.at>
 <20140304184109.GB19393@redhat.com>
 <53163ADE.8080905@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53163ADE.8080905@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:43:10PM +0100, Richard Weinberger wrote:
> I remember a discussion with Al where he noted that register_exec_domain()
> is currently only used by out of tree horrors. B-)
> 
> I'm sure we can rip it out of most archs. They seem to have it only because
> they've copy&pasted it from i386.

We do have a few in-tree uses obviously.  Would be good to know how much
of that actuall is used.

Except for that the major users is iBCS which became linux-abi long time
ago.  I think someone is still keeing it on life support and
occasionally forward porting it, but that's not a reason to keep any of
this in tree.  Back when I maintained it linux-abi already was a large
patch to core code and not just modules, and I doubt that has changed in
the last 10 years.
