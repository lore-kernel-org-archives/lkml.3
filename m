Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3LCQmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:42:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:64063 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3LCQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:41:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="77809994"
Message-ID: <1386088897.13256.66.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v2] xen/block: Correctly define structures in public
 headers on ARM32 and ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Julien Grall <julien.grall@linaro.org>, <xen-devel@lists.xenproject.org>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Tue, 3 Dec 2013 16:41:37 +0000
In-Reply-To: <20131203163228.3313dff8@alan.etchedpixels.co.uk>
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
	 <20131203160018.67542a53@alan.etchedpixels.co.uk>
	 <529E04AB.5060304@linaro.org>
	 <20131203163228.3313dff8@alan.etchedpixels.co.uk>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 16:32 +0000, One Thousand Gnomes wrote:
> > > How does the patch ensure new kernels on existing hypervisor versions
> > > don't break ?
> > 
> > As Ian said on the thread "xen-block: correctly define structures in
> > public headers" (see thread https://lkml.org/lkml/2013/12/3/155), the
> > ABI is not yet fixed for ARM.
> 
> And if you are one of the existing users that helps how ?

The existing users are using something which was explicitly marked as a
tech preview and for which it was stated clearly that the ABI was not
set in stone. They know to expect this sort of thing and have
experienced it more than once already as this stuff was developed.

This is actually something of a red-herring though, this is a protocol
between two peers and it has now transpired that Linux was not
implementing the specified protocol, even though it was able to talk to
itself. The protocol is defined by an entity which is external to Linux.
If this had been a bug in the IP protocol handling we would fix it and
move on. This case is no different IMHO.

> > > It seems to me you should be defining
> > > 
> > > struct blkif_request_rw_v2
> > > 
> > > and using the correct version according to which API the hypervisor
> > > requires, not just breaking it.
> > 
> > This API doesn't involve the hypervisor. It's only a way to talk between
> > DOM0 and a guest. Without this change you will break compatibility with
> > other OSes.
> 
> With this change you break compatibility between the existing OS's,new
> guests and old DOM0 and vice versa.
> 
> If a request in old format is guaranteed to error in new format (or you
> can construct one that will) then you can trivially support both APIs on
> the guest side at least for a while. That will avoid regressions when
> people mix versions and also mean you've got a much better ability to
> find a bug if stuff breaks as you won't have to switch guest and dom0
> together when debugging.

Once we set the ABI in stone then this is the sort of thing we will care
very much about (as we have done for many years on x86). Until then it
is not.

Ian.

