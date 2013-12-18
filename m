Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3LRTBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:01:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47158 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3LRTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:01:11 -0500
Date: Wed, 18 Dec 2013 11:01:08 -0800
From: josh@joshtriplett.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: Add prototype declaration in memory.c
Message-ID: <20131218190108.GL24229@cloud>
References: <20131218063953.GA3180@rashika>
 <20131218153451.GA22228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131218153451.GA22228@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 07:34:51AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 18, 2013 at 12:09:53PM +0530, Rashika Kheria wrote:
> > Add the prototype declaration of function memory_block_size_bytes() in
> > memory.c.
> > 
> > This eliminates the following warning in memory.c:
> > drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  drivers/base/memory.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index bece691..cfa03de 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -83,6 +83,7 @@ static void memory_block_release(struct device *dev)
> >  	kfree(mem);
> >  }
> >  
> > +unsigned long __weak memory_block_size_bytes(void);
> >  unsigned long __weak memory_block_size_bytes(void)
> 
> If this patch is the "solution" then something else is really wrong
> here, please use your judgement to realize this...

It's a weak symbol provided and consumed within the same file, and then
overridden on a few random architectures.  It isn't currently prototyped
in any header file.  The other potential solution would be to add it to
an appropriate existing header or create a new one.  Any suggestions for
an appropriate existing header to prototype it in instead?

- Josh Triplett
