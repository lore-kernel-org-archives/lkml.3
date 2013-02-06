Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3BFTJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:09:30 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:54356 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3BFTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:09:27 -0500
Date: Wed, 6 Feb 2013 11:09:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie
 to a config option
Message-ID: <20130206190924.GB32275@kroah.com>
References: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 10:27:41AM -0800, Dan Magenheimer wrote:
> It was observed by Andrea Arcangeli in 2011 that zcache can get "full"
> and there must be some way for compressed swap pages to be (uncompressed
> and then) sent through to the backing swap disk.  A prototype of this
> functionality, called "unuse", was added in 2012 as part of a major update
> to zcache (aka "zcache2"), but was left unfinished due to the unfortunate
> temporary fork of zcache.
> 
> This earlier version of the code had an unresolved memory leak
> and was anyway dependent on not-yet-upstream frontswap and mm changes.
> The code was meanwhile adapted by Seth Jennings for similar
> functionality in zswap (which he calls "flush").  Seth also made some
> clever simplifications which are herein ported back to zcache.  As a
> result of those simplifications, the frontswap changes are no longer
> necessary, but a slightly different (and simpler) set of mm changes are
> still required [1].  The memory leak is also fixed.
> 
> Due to feedback from akpm in a zswap thread, this functionality in zcache
> has now been renamed from "unuse" to "writeback".
> 
> Although this zcache writeback code now works, there are open questions
> as how best to handle the policy that drives it.  As a result, this
> patch also ties writeback to a new config option.  And, since the
> code still depends on not-yet-upstreamed mm patches, to avoid build
> problems, the config option added by this patch temporarily depends
> on "BROKEN"; this config dependency can be removed in trees that
> contain the necessary mm patches.

I'll wait for those options to be in Linus's tree before accepting a
patch like this, sorry.

greg k-h
