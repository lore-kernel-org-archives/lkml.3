Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaB0EIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:08:51 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48611 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752908AbaB0EIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:08:50 -0500
Date: Wed, 26 Feb 2014 20:00:50 -0800
From: Ben Pfaff <blp@nicira.com>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227040050.GA8449@nicira.com>
References: <530E6F76.1070605@zytor.com>
 <1393462087.24588.50.camel@joe-AO722>
 <530E8C2E.7080307@zytor.com>
 <1393466619.24588.65.camel@joe-AO722>
 <20140227022857.GC23659@thin>
 <1393469594.24588.71.camel@joe-AO722>
 <20140227025845.GA25145@thin>
 <530EB103.5070406@zytor.com>
 <1393472326.24588.82.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393472326.24588.82.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:38:46PM -0800, Joe Perches wrote:
> (adding Ben Pfaff and Christopher Li)
> 
> On Wed, 2014-02-26 at 19:29 -0800, H. Peter Anvin wrote:
> > On 02/26/2014 06:58 PM, Josh Triplett wrote:
> > > On Wed, Feb 26, 2014 at 06:53:14PM -0800, Joe Perches wrote:
> > >> Allow an override to emit or not the sizeof(bool) warning
> > >> Add a description to the manpage.
> > >>
> > >> Signed-off-by: Joe Perches <joe@perches.com>
> > > 
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > 
> > 
> > I have to admit that this particular warning is a bit odd to me.  I'm
> > wondering what kind of bugs it was intended to catch.
> > 
> > In particular, things that incorrectly assumes the size of bool to be
> > anything in particular would seem unlikely to actually use sizeof().
> 
> Dunno, the commit log for the commit that added it doesn't quite
> match the code and is seemingly unaware that the c99 spec doesn't
> specify sizeof(bool).

The commit *relaxed* sparse behavior: because previously sizeof(bool)
was an error.  I'm not in favor of any diagnostic at all for
sizeof(bool), but my recollection is that a sparse maintainer wanted it
to yield one.

I don't care about the particular result for sizeof(bool) as long as it
matches the ABI.
