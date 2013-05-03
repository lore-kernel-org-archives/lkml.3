Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab3ECQAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:00:21 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:7690 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3ECQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:00:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4215374"
Message-ID: <1367596817.28742.123.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 2/2] xen/balloon: Enforce various limits
 on target
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Keir (Xen.org)" <keir@xen.org>,
        "Dave Scott" <Dave.Scott@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Ludlam" <Jonathan.Ludlam@eu.citrix.com>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "carsten@schiers.de" <carsten@schiers.de>
Date: Fri, 3 May 2013 17:00:17 +0100
In-Reply-To: <20130503154724.GC12463@debian70-amd64.local.net-space.pl>
References: <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
	 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
	 <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
	 <alpine.DEB.2.02.1305021214510.5398@kaball.uk.xensource.com>
	 <20130502180404.GA16489@phenom.dumpdata.com>
	 <1367568932.28742.19.camel@zakaz.uk.xensource.com>
	 <20130503130036.GA12463@debian70-amd64.local.net-space.pl>
	 <1367587284.28742.89.camel@zakaz.uk.xensource.com>
	 <20130503134704.GB12463@debian70-amd64.local.net-space.pl>
	 <1367590278.28742.108.camel@zakaz.uk.xensource.com>
	 <20130503154724.GC12463@debian70-amd64.local.net-space.pl>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 16:47 +0100, Daniel Kiper wrote:
> > > > > Do not forget that guest may change target itself.
> > > >
> > > > Yes it can, and that can fail either due to maxmem or due to ENOMEM, and
> > > > the kernel needs prepared to deal with that when it happens.
> > >
> > > Sure but why we would like to fail in endless loop if maxmem case
> > > could be easliy detected by checking XENMEM_maximum_reservation?
> >
> > That endless loop is deliberate. When a target is set the balloon driver
> > is supposed to try to reach it and if it fails at any given moment it is
> > supposed to try again. This all relates to the changes made in
> > bc2c0303226e.
> >
> > Now you could argue that this case is subtly different from the ENOMEM
> > case which was the primary focus of that commit but have you thought
> > about the behaviour you want in the case where maximum_reservation is
> > subsequently raised? IMHO there's no reason why the balloon driver
> > shouldn't then automatically make further progress towards the target.
> 
> OK, now it makes sens. Do we assume the same behavior for dom0?
> Could we change maximum_reservation for dom0 using xl?

I don't think there's any reason to special case dom0 here.

> > If the infinite loop bothers you then perhaps an exponential backoff in
> > the frequency of attempts would be a suitable middle ground?
> 
> Relevant patches made by me are merged some time ago.

Great!

> > > > > Additionally, we would like to introduce xm compatibility
> > > > > mode which is a bit different then xl normal behavior.
> > > >
> > > > When then you really don't want to be baking specifics of the current
> > > > model into the kernel, do you.
> > >
> > > Hmmm... Little misunderstanding. As I stated a few times I do not
> > > want bake any libxl or Xen stuff into Linux Kernel (including
> > > LIBXL_MAXMEM_CONSTANT). I just want to check limits which I think
> > > make sense in this case.
> >
> > Sorry, I never noticed you saying that. Where was it?
> 
> Here http://lists.xen.org/archives/html/xen-devel/2013-04/msg03259.html
> I stated that I do not like this constant. I explained why this was done
> in that way.

Sorry, I read that mail as arguing that it must be done this way ("this
is a must").

>  Later I found relevant commit which introduced it and asked
> authors about it. I think that shows that I am not happy with
> LIBXL_MAXMEM_CONSTANT and I am looking for good solution for this problem.

Ian.

