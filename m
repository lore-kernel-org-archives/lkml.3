Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaILSwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:52:45 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35733 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaILSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:52:44 -0400
Date: Sat, 13 Sep 2014 03:52:38 +0900
From: Tejun Heo <tj@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH/RFC 1/2] lib: string: Remove duplicated function
Message-ID: <20140912185238.GD6298@mtj.dyndns.org>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
 <1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
 <20140911152241.22ce7f1ebecef7ce7e01b112@linux-foundation.org>
 <87d2b1jjqa.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2b1jjqa.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 12, 2014 at 11:01:17AM +0200, Rasmus Villemoes wrote:
> On Fri, Sep 12 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 27 Aug 2014 09:36:01 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> >> strncasecmp is the POSIX name for this functionality. So rename the
> >> non-broken function to the standard name. To minimize the impact on
> >> the rest of the kernel (and since both are exported to modules), make
> >> strnicmp a wrapper for strncasecmp.

Maybe it's a good idea to convert all existing users of strnicmp()
strncasecmp() and then mark the strnicmp() wrapper as __deprecated for
later removal?

> > I guess it's safe to assume that nobody was depending on the
> > strncasecmp() bug.
> 
> Hm, I thought so as well, but decided to double check. I found one minor
> issue; maybe Tejun can tell if my analysis is correct.
> 
> In drivers/ata/libata-core.c, ata_parse_force_one(), it is not
> immediately clear to me that val cannot end up being the empty
> string. With the buggy strncasecmp, the continue branch is always
> followed (since fp->name is not empty); however, with strncasecmp with
> the correct semantics, the empty string is obviously a prefix of every
> fp->name. So even though the comment says that "1.5" is an ok
> abbreviation of "1.5Gbps", I don't think the intention was to allow ""
> to be an abbreviation of everything. Anyway, the worst that can happen
> seems to be that "ambigious value" [sic] becomes the *reason instead
> of "unknown value".

Sounds right to me and it shouldn't matter at all.

> > Yes, please prepare the strnicmp()->strncasecmp() patches and let's get
> > them merged up.  After a kernel release or two we can zap the
> > back-compat wrapper.

Ooh, somebody already suggested the same. :)

Thanks.

-- 
tejun
