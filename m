Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3IIJgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:36:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3IIJgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:36:21 -0400
Date: Mon, 9 Sep 2013 11:36:18 +0200
From: Jan Kara <jack@suse.cz>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, kbuild-all@01.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile: rework <asm/cmpxchg.h>
Message-ID: <20130909093618.GB1612@quack.suse.cz>
References: <52274d0f.jLRsYGUvhePuFG6l%fengguang.wu@intel.com>
 <20130904163122.GH3996@quack.suse.cz>
 <201309061310.r86DA9OU025982@farm-0021.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309061310.r86DA9OU025982@farm-0021.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-09-13 08:56:45, Chris Metcalf wrote:
> The macrology in cmpxchg.h was designed to allow arbitrary pointer
> and integer values to be passed through the routines.  To support
> cmpxchg() on 64-bit values on the 32-bit tilepro architecture, we
> used the idiom "(typeof(val))(typeof(val-val))".  This way, in the
> "size 8" branch of the switch, when the underlying cmpxchg routine
> returns a 64-bit quantity, we cast it first to a typeof(val-val)
> quantity (i.e. size_t if "val" is a pointer) with no warnings about
> casting between pointers and integers of different sizes, then cast
> onwards to typeof(val), again with no warnings.  If val is not a
> pointer type, the additional cast is a no-op.  We can't replace the
> typeof(val-val) cast with (for example) unsigned long, since then if
> "val" is really a 64-bit type, we cast away the high bits.
  Ah, I see. Thanks for explanation.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
