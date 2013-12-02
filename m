Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3LBTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:08:27 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45653 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab3LBTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:08:19 -0500
X-Sasl-enc: dGBrUzj9hijgM3dM6Q7wfH0XtG8PotqHi0R0SwxV1aQ/ 1386011295
Date: Mon, 2 Dec 2013 11:08:14 -0800
From: Greg KH <greg@kroah.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: netfilter: active obj WARN when cleaning up
Message-ID: <20131202190814.GA2267@kroah.com>
References: <alpine.DEB.2.02.1311271409280.30673@ionos.tec.linutronix.de>
 <20131127133231.GO16735@n2100.arm.linux.org.uk>
 <20131127134015.GA6011@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1311271443580.30673@ionos.tec.linutronix.de>
 <20131127233415.GB19270@kroah.com>
 <00000142b4282aaf-913f5e4c-314c-4351-9d24-615e66928157-000000@email.amazonses.com>
 <20131202164039.GA19937@kroah.com>
 <00000142b4514eb5-2e8f675d-0ecc-423b-9906-58c5f383089b-000000@email.amazonses.com>
 <20131202172615.GA4722@kroah.com>
 <00000142b4aeca89-186fc179-92b8-492f-956c-38a7c196d187-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142b4aeca89-186fc179-92b8-492f-956c-38a7c196d187-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 07:00:23PM +0000, Christoph Lameter wrote:
> On Mon, 2 Dec 2013, Greg KH wrote:
> 
> > >
> > > We need our own reference count. So we just have to defer the
> > > release of the kmem_cache struct until the ->release callback is
> > > triggered. The put of the embedded kobject must be the last action on the
> > > kmem_cache  structure which will then trigger release and that will
> > > trigger the kmem_cache_free().
> > >
> >
> > Ok, that sounds reasonable, or you can just create a "tiny" structure
> > for the kobject that has a pointer back to your kmem_cache structure
> > that you can then reference from the show/store functions.  Either is
> > fine with me.
> 
> Problem is that the release field is only available if
> CONFIG_DEBUG_KOBJECT_RELEASE is enabled. Without the callback I cannot
> tell when it is legit to release the kobject structure unless I keep
> scanning it once in awhile.

No, the release callback is in the kobj_type, not the kobject itself.

