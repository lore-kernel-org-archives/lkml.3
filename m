Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3APVXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:23:36 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39898 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab3APVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:23:34 -0500
Date: Wed, 16 Jan 2013 22:17:26 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: kernel/sbus.c: fix memory leakage
Message-ID: <20130116211725.GC18593@gmail.com>
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com>
 <20130116211309.GA13993@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116211309.GA13993@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:13:09PM +0100, Sam Ravnborg wrote:
> On Mon, Jan 14, 2013 at 10:36:08PM +0100, Cong Ding wrote:
> > the variable iommu and strbuf are not freed if it goes to error.
> > 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  arch/sparc/kernel/sbus.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
> > index 1271b3a..0b66e53 100644
> > --- a/arch/sparc/kernel/sbus.c
> > +++ b/arch/sparc/kernel/sbus.c
> > @@ -555,10 +555,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
> >  
> >  	iommu = kzalloc(sizeof(*iommu), GFP_ATOMIC);
> >  	if (!iommu)
> > -		goto fatal_memory_error;
> > +		goto fatal_iommu_memory_error;
> >  	strbuf = kzalloc(sizeof(*strbuf), GFP_ATOMIC);
> >  	if (!strbuf)
> > -		goto fatal_memory_error;
> > +		goto fatal_strbuf_memory_error;
> >  
> >  	op->dev.archdata.iommu = iommu;
> >  	op->dev.archdata.stc = strbuf;
> > @@ -656,6 +656,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
> >  	return;
> >  
> >  fatal_memory_error:
> > +	kfree(strbuf);
> > +fatal_strbuf_memory_error:
> > +	kfree(iommu);
> > +fatal_iommu_memory_error:
> >  	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
> >  }
> kfree is a noop if passed a null pointer.
> So you can just add the missing kfree's to fix this.
> 
> 	Sam
as far as I know, most codes in the kernel are in the same style as this
patch, but if you really prefer to do in the way you described I can send
a new version.

Let me know.

- cong

