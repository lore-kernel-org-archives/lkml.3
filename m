Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaLQKyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:54:16 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54484 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:54:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 13/18] powerpc/uaccess: fix sparse errors
Date: Wed, 17 Dec 2014 11:53:56 +0100
Message-ID: <3268591.VzqP3kr6UD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418777556.27103.7.camel@kernel.crashing.org>
References: <1418575877-21488-1-git-send-email-mst@redhat.com> <20141216164746.GB21876@redhat.com> <1418777556.27103.7.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:nBp2tbokz3u5050ideeD8vhqhJ/RnkvHu4YgOhGT8CdoPPMvwl+
 FFZRMfdG5P+hsVLvCEbK0x/HdBN2qBHw4eVHTtJzopuoewNrU8rmitKhpqOpIEDaoC0kqvS
 S2epPflZlz2g9wJM8JTgjR5eU19MsNP5OjnlK2Kl78Qevf4ZwF9Xqc0i7mAl5plTKTo+lmd
 VYNhH8qZHgCC4ayY1WUtw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 11:52:36 Benjamin Herrenschmidt wrote:
> On Tue, 2014-12-16 at 18:47 +0200, Michael S. Tsirkin wrote:
> > On Sun, Dec 14, 2014 at 06:52:51PM +0200, Michael S. Tsirkin wrote:
> > > virtio wants to read bitwise types from userspace using get_user.  At the
> > > moment this triggers sparse errors, since the value is passed through an
> > > integer.
> > > 
> > > Fix that up using __force.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Ping.
> > Do powerpc maintainers consider fixing sparse errors
> > applicable for 3.19?
> > If yes, can you pls merge this patch?
> 
> Relax  Our patches are tracked in Patchwork and such fixes aren't
> necessarily constrained by the merge window. Michael will probably
> pick it up but don't expect systematic replies to patches in 2 days ...
> 
> Also, when sending a series like that where one of us only gets
> CCed on one of the patch, it helps to make it clear whether you
> only expect an ack or whether you expect us to take the patch.

Michael initially asked how these patches should merged, and as I
discussed with him on IRC, I wouldn't take them through the asm-generic
tree for 3.19 at this point, but I offered to take the ones that
are not picked up by arch maintainers through that tree for 3.20.

I also recommend to him to clarify this with maintainers of the
architectures he cares about most so they can decide whether to pick
it up or not, which triggered the message above.

	Arnd
