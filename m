Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713Ab3ECIEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:04:32 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:55907 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3ECIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:04:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4193446"
Message-ID: <1367568263.28742.11.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 2/2] xen/balloon: Enforce various limits
 on target
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Keir (Xen.org)" <keir@xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "carsten@schiers.de" <carsten@schiers.de>
Date: Fri, 3 May 2013 09:04:23 +0100
In-Reply-To: <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
	 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
	 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
	 <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
	 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
	 <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 19:58 +0100, Daniel Kiper wrote:
> On Tue, Apr 30, 2013 at 02:44:18PM +0100, Ian Campbell wrote:
> > On Tue, 2013-04-30 at 13:59 +0100, Daniel Kiper wrote:
> > > On Mon, Apr 29, 2013 at 03:44:09PM +0100, Ian Campbell wrote:
> > > > On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:
> > > >
> > > > > This patch enforces on target limit statically defined in Linux Kernel
> > > > > source and limit defined by hypervisor or host. This way the balloon
> > > > > driver should not attempt to populate pages above given limits
> > > > > because they may fail.
> > > > >
> > > > > Particularly this patch fixes bug which led to flood
> > > > > of dom0 kernel log with messages similar to:
> > > > >
> > > > > System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> > > > > xen_balloon: reserve_additional_memory: add_memory() failed: -17
> > > >
> > > > I think it would be OK to simply tone down this message (and perhaps add
> > > > the failed pages to the balloon, if that makes sense). This isn't
> > > > dissimilar to increase_reservation failing.
> > >
> > > If add_memory() fails it is hard error. It means that we do not
> > > know where new or ballooned pages should be placed.
> >
> > I see that add_memory() is a generic or arch level function rather than
> > a ballooning specific one. Under what circumstances can it fail and how
> > do they relate the the setting of the balloon target?
> 
> It is generic function with some references to arch code. It is called
> when pages could not be taken from balloon any more and must be hotplugged.
> It reserves memory resource (start address and size is calculated on the
> base of target and max_pfn) and build some structures for new memory.
> It may fail in many places. In this case it failed because placement
> of new resource was incorrectly calculated because algorithm is very
> simple and not cover all cases. I am going to fix this issue but
> a bit later.

I think you should fix that core issue first, otherwise the requirement
for messing with the balloon target is not very obvious.

Ian.

