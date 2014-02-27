Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaB0E0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:26:42 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50923 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751700AbaB0E0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:26:40 -0500
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2014 23:26:40 EST
Date: Wed, 26 Feb 2014 20:26:36 -0800
From: Ben Pfaff <blp@nicira.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227042636.GA9592@nicira.com>
References: <1393462087.24588.50.camel@joe-AO722>
 <530E8C2E.7080307@zytor.com>
 <1393466619.24588.65.camel@joe-AO722>
 <20140227022857.GC23659@thin>
 <1393469594.24588.71.camel@joe-AO722>
 <20140227025845.GA25145@thin>
 <530EB103.5070406@zytor.com>
 <1393472326.24588.82.camel@joe-AO722>
 <20140227040050.GA8449@nicira.com>
 <530EBCED.9020705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530EBCED.9020705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 08:19:57PM -0800, H. Peter Anvin wrote:
> On 02/26/2014 08:00 PM, Ben Pfaff wrote:
> > 
> > The commit *relaxed* sparse behavior: because previously sizeof(bool)
> > was an error.  I'm not in favor of any diagnostic at all for
> > sizeof(bool), but my recollection is that a sparse maintainer wanted it
> > to yield one.
> 
> Still not clear as to why.

The discussion is here:
        http://comments.gmane.org/gmane.comp.parsers.sparse/2462

Quoting from that discussion, the core of Christopher Li's argument was
this:
> On Mon, May 9, 2011 at 1:02 PM, Ben Pfaff <blp <at> nicira.com> wrote:
> > Thank you for applying my patch.  It does work for me, in the sense
> > that I get a warning instead of an error now, but I'm not so happy to
> > get any diagnostic at all.  Is there some reason why sizeof(_Bool)
> > warrants a warning when, say, sizeof(long) does not?  After all, both
> > sizes are implementation defined.

> Because sizeof(_Bool) is a little bit special compare to sizeof(long).
> In the case of long, all sizeof(long) * 8 bits are use in the actual value.
> But for the _Bool, only the 1 bit is used in the 8 bits size. In other words,
> the _Bool has a special case of the actual bit size is not a multiple of 8.

> Sparse has two hats, it is a C compiler front end, and more often it is
> used in the Linux kernel source sanitize checking. Depending on the sizeof
> _Bool sounds a little bit suspicious in the kernel. I would love to the heard
> your actual usage case of the sizeof(_Bool). Why do you care about this
> warning?
