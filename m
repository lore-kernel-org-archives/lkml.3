Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaEFMbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:31:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:36151 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbaEFMbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:31:37 -0400
Date: Tue, 6 May 2014 14:31:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: fs: dcookie: freeing active timer
In-Reply-To: <20140505135123.c7e23560b68e19e9a247e237@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1405060104140.6261@ionos.tec.linutronix.de>
References: <53594244.6070305@oracle.com> <20140424172708.GY18016@ZenIV.linux.org.uk> <53594B16.4000901@oracle.com> <20140424215558.GZ18016@ZenIV.linux.org.uk> <20140424234941.GA18016@ZenIV.linux.org.uk> <5359D70B.2070604@oracle.com> <53616F92.4020709@oracle.com>
 <alpine.DEB.2.10.1404301819140.27262@gentwo.org> <20140501131005.2aca98242477d8f98e33b19f@linux-foundation.org> <5367F832.4090901@oracle.com> <20140505135123.c7e23560b68e19e9a247e237@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Andrew Morton wrote:

> On Mon, 05 May 2014 16:44:34 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
> > On 05/01/2014 04:10 PM, Andrew Morton wrote:
> > >> On Wed, 30 Apr 2014, Sasha Levin wrote:
> > >> > 
> > >>>> > > > Could someone pretty please merge that patch? Specially since Greg acked it?
> > >>> > >
> > >>> > > Ping?
> > >> > 
> > >> > Ok please repost. Andrew or Pekka can merge it.
> > > OK, I seem to have pieced it all together.  The changelog sucked :( I
> > > fixed it up a bit but I still don't see why we added that
> > > SLAB_SUPPORTS_SYSFS thing.  Why do slab and slub differ here?  What
> > > about slob?
> > > 
> > > A number of rejects had to be fixed.  Please check this over carefully.
> > 
> > That patch fixed the issues I've been seeing, and I'm not seeing any new
> > issues caused by the patch.
> 
> OK, thanks.  That patch was busted with CONFIG_SYSFS=n and I ended up
> moving things around quite a bit to fix that.  The new version is
> below.
> 
> I'll queue this for 3.15 but not for -stable: I don't think we care a
> lot about debugobjects warnings in stable kernels?

If debugobjects warns you about freeing an active timer, then you
better care. With debugobjects disabled the kernel will just crash in
the timer softirq or explode somewhere else.

Thanks,

	tglx
