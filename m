Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3LBTQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:16:07 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:42933 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab3LBTQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:03 -0500
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 14:16:03 EST
Date: Mon, 2 Dec 2013 19:00:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Greg KH <greg@kroah.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: netfilter: active obj WARN when cleaning up
In-Reply-To: <20131202172615.GA4722@kroah.com>
Message-ID: <00000142b4aeca89-186fc179-92b8-492f-956c-38a7c196d187-000000@email.amazonses.com>
References: <alpine.DEB.2.02.1311271106090.30673@ionos.tec.linutronix.de> <20131127113939.GL16735@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1311271409280.30673@ionos.tec.linutronix.de> <20131127133231.GO16735@n2100.arm.linux.org.uk> <20131127134015.GA6011@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1311271443580.30673@ionos.tec.linutronix.de> <20131127233415.GB19270@kroah.com> <00000142b4282aaf-913f5e4c-314c-4351-9d24-615e66928157-000000@email.amazonses.com> <20131202164039.GA19937@kroah.com>
 <00000142b4514eb5-2e8f675d-0ecc-423b-9906-58c5f383089b-000000@email.amazonses.com> <20131202172615.GA4722@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.02-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Greg KH wrote:

> >
> > We need our own reference count. So we just have to defer the
> > release of the kmem_cache struct until the ->release callback is
> > triggered. The put of the embedded kobject must be the last action on the
> > kmem_cache  structure which will then trigger release and that will
> > trigger the kmem_cache_free().
> >
>
> Ok, that sounds reasonable, or you can just create a "tiny" structure
> for the kobject that has a pointer back to your kmem_cache structure
> that you can then reference from the show/store functions.  Either is
> fine with me.

Problem is that the release field is only available if
CONFIG_DEBUG_KOBJECT_RELEASE is enabled. Without the callback I cannot
tell when it is legit to release the kobject structure unless I keep
scanning it once in awhile.


