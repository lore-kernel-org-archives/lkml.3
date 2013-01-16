Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3APWAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:00:22 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:39473 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab3APWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:00:20 -0500
Date: Wed, 16 Jan 2013 23:00:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: kernel/sbus.c: fix memory leakage
Message-ID: <20130116220018.GA14063@merkur.ravnborg.org>
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com> <20130116211309.GA13993@merkur.ravnborg.org> <20130116211725.GC18593@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116211725.GC18593@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:17:26PM +0100, Cong Ding wrote:
> On Wed, Jan 16, 2013 at 10:13:09PM +0100, Sam Ravnborg wrote:
> > On Mon, Jan 14, 2013 at 10:36:08PM +0100, Cong Ding wrote:
> > > the variable iommu and strbuf are not freed if it goes to error.
> > > 
> > > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > > ---
> > >  arch/sparc/kernel/sbus.c |    8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
> > > index 1271b3a..0b66e53 100644
> > > --- a/arch/sparc/kernel/sbus.c
> > > +++ b/arch/sparc/kernel/sbus.c
> > > @@ -555,10 +555,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
> > >  
> > >  	iommu = kzalloc(sizeof(*iommu), GFP_ATOMIC);
> > >  	if (!iommu)
> > > -		goto fatal_memory_error;
> > > +		goto fatal_iommu_memory_error;
> > >  	strbuf = kzalloc(sizeof(*strbuf), GFP_ATOMIC);
> > >  	if (!strbuf)
> > > -		goto fatal_memory_error;
> > > +		goto fatal_strbuf_memory_error;
> > >  
> > >  	op->dev.archdata.iommu = iommu;
> > >  	op->dev.archdata.stc = strbuf;
> > > @@ -656,6 +656,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
> > >  	return;
> > >  
> > >  fatal_memory_error:
> > > +	kfree(strbuf);
> > > +fatal_strbuf_memory_error:
> > > +	kfree(iommu);
> > > +fatal_iommu_memory_error:
> > >  	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
> > >  }
> > kfree is a noop if passed a null pointer.
> > So you can just add the missing kfree's to fix this.
> > 
> > 	Sam
> as far as I know, most codes in the kernel are in the same style as this
> patch, but if you really prefer to do in the way you described I can send
> a new version.

I prefer the simpler variant.
Please redo.

	Sam
