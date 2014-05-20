Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaETIUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:20:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22150 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaETIUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:20:11 -0400
Date: Tue, 20 May 2014 11:19:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] module: static checker complains about negative values
Message-ID: <20140520081957.GD15585@mwanda>
References: <20140519203626.GC5671@mwanda>
 <87y4xxi5nn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4xxi5nn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:16:04AM +0930, Rusty Russell wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > We cap "stat.size" at INT_MAX but we don't check for negative values so
> > my static checker complains.  At this point, you already have control of
> > the kernel and if you start passing negative values here then you
> > deserve what happens next.
> >
> > On 64 bit systems the vmalloc() will definitely fail.  On 32 bit systems
> > we truncate the upper 32 bits away so that could succeed.  I haven't
> > followed it further than that.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> If vfs_getattr() returns a negative stat.size, we have worse problems.
> 
> I'd rather see you sprinkle assertions like that into the code, so we
> can make sure that can't happen for any fs's getattr().

Yeah.  I was lazy.  Sorry.  I can just hand edit my database to say that
i_size_read() returns a reasonable number...

regards,
dan carpenter

