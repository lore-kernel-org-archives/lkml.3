Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3IERNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:13:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56931 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IERNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:13:45 -0400
Date: Thu, 5 Sep 2013 13:13:38 -0400
From: Kyle McMartin <kyle@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: Export flush_cache_page() (needed by lustre)
Message-ID: <20130905171338.GB25882@merlin.infradead.org>
References: <1378373595-29471-1-git-send-email-geert@linux-m68k.org>
 <1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:01:59AM -0700, James Bottomley wrote:
> > +EXPORT_SYMBOL_GPL(flush_cache_page);
> 
> This is an internal API: no architecture exports this.  Whoever is
> trying to use it needs to use the correct API, so this is the wrong
> patch.
> 

I suspect it's copy_{to,from}_user_page being called here:

drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c:
copy_to_user_page(vma, page, addr,

which we could probably take out of line.

--Kyle
