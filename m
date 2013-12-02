Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3LBQkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:40:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41221 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab3LBQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:40:42 -0500
X-Sasl-enc: BjMA7wkryL30Es6V92yXzRhATJ0pjveGkfzDGZk1Zhbk 1386002441
Date: Mon, 2 Dec 2013 08:40:39 -0800
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
Message-ID: <20131202164039.GA19937@kroah.com>
References: <5294F27D.4000108@oracle.com>
 <20131126230709.GA10948@localhost>
 <alpine.DEB.2.02.1311271106090.30673@ionos.tec.linutronix.de>
 <20131127113939.GL16735@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1311271409280.30673@ionos.tec.linutronix.de>
 <20131127133231.GO16735@n2100.arm.linux.org.uk>
 <20131127134015.GA6011@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1311271443580.30673@ionos.tec.linutronix.de>
 <20131127233415.GB19270@kroah.com>
 <00000142b4282aaf-913f5e4c-314c-4351-9d24-615e66928157-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142b4282aaf-913f5e4c-314c-4351-9d24-615e66928157-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:33:20PM +0000, Christoph Lameter wrote:
> On Wed, 27 Nov 2013, Greg KH wrote:
> 
> > Just make the kobject "dynamic" instead of embedded in struct kmem_cache
> > and all will be fine.  I can't believe this code has been broken for
> > this long.
> 
> The slub code is was designed to use an embedded structure since we
> only get the kobj  pointer passed to us from sysfs. If kobj is not
> embedded then how can we get from the sysfs object to the kmem_cache
> structure from the sysfs callbacks? Sysfs was designed to have embedded
> objects as far as I can recall.

Yes, it's designed to have embedded objects, so then use it that way and
clean up the structure when the kobject goes away.  Don't use a
different reference count for your structure than the one in the kobject
and think that all will be fine.

greg k-h
