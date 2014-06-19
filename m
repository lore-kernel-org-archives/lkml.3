Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaFSOfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:35:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:61783 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFSOfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:35:04 -0400
Date: Thu, 19 Jun 2014 10:34:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: percpu: micro-optimize round-to-even
Message-ID: <20140619143458.GF26904@htj.dyndns.org>
References: <1403172149-25353-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140619132536.GF11042@htj.dyndns.org>
 <alpine.DEB.2.11.1406190925430.2785@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406190925430.2785@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:29:52AM -0500, Christoph Lameter wrote:
> > > -	if (unlikely(size & 1))
> > > -		size++;
> > > +	size += size & 1;
> >
> > I'm not gonna apply this.  This isn't that hot a path.  It's not
> > worthwhile to micro optimize code like this.
> 
> Dont we have an ALIGN() macro for this?

Indeed, a patch?

-- 
tejun
