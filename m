Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaGBS66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:58:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49779 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbaGBS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:58:57 -0400
X-IronPort-AV: E=Sophos;i="5.01,590,1400025600"; 
   d="scan'208";a="149543892"
Message-ID: <1404327535.28016.49.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH net-next] xen-netback: Adding debugfs "io_ring_qX" files
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Date: Wed, 2 Jul 2014 19:58:55 +0100
In-Reply-To: <53B452CD.7020903@citrix.com>
References: <1404160411-23747-1-git-send-email-zoltan.kiss@citrix.com>
	 <1404298567.5562.13.camel@kazak.uk.xensource.com>
	 <53B452CD.7020903@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 19:43 +0100, Zoltan Kiss wrote:
> On 02/07/14 11:56, Ian Campbell wrote:
> > On Mon, 2014-06-30 at 21:33 +0100, Zoltan Kiss wrote:
> >> This patch adds debugfs capabilities to netback. There used to be a similar
> >> patch floating around for classic kernel, but it used procfs. It is based on a
> >> very similar blkback patch.
> >> It creates xen-netback/[vifname]/io_ring_q[queueno] files, reading them output
> >> various ring variables etc. Writing "kick" into it imitates an interrupt
> >> happened, it can be useful to check whether the ring is just stalled due to a
> >> missed interrupt.
> >
> > Shouldn't there be some CONFIG_XEN_DEBUG_FS ifdefs sprinkled around
> > here?
> 
> Good question! I've checked where else is this used, it is in 
> arch/x86/xen, particularly in spinlock.c and p2m.c. The goal there is, 
> as far as I see, to make it configurable whether you want debugging in 
> fast path. However here in netback it's not fast path.
> It would be nice to have this netback debugfs stuff in production 
> systems, but if it is tied to this same config option, that wouldn't be 
> possible.
> So either we don't put it behind a config option, or create a whole new 
> one just for this. I don't see the benefit of the latter one, so I would 
> prefer keep it like it is now.

Sorry, I meant CONFIG_DEBUG_FS (i.e. the top level option for the whole
debugfs thing being available at all) but I cut-n-pasted the wrong
thing.

Ian.

