Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaKZOSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:18:06 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42994 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaKZOSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:18:01 -0500
Date: Wed, 26 Nov 2014 15:17:50 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 25/42] vhost: add memory access wrappers
Message-ID: <20141126151750.61a40fe4.cornelia.huck@de.ibm.com>
In-Reply-To: <20141126140539.GA5528@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-26-git-send-email-mst@redhat.com>
	<20141126145438.4421c00d.cornelia.huck@de.ibm.com>
	<20141126140539.GA5528@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112614-0013-0000-0000-000001FF5B79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 16:05:39 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Nov 26, 2014 at 02:54:38PM +0100, Cornelia Huck wrote:
> > On Tue, 25 Nov 2014 18:43:10 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:

> > > @@ -174,6 +174,37 @@ enum {
> > > 
> > >  static inline int vhost_has_feature(struct vhost_virtqueue *vq, int bit)
> > >  {
> > > -	return vq->acked_features & (1 << bit);
> > > +	return vq->acked_features & (1ULL << bit);
> > 
> > Should this hunk go into patch 28?
> 
> Well, this is needed here since 1 << 32 is not legal C.
> 
> I can move it - this means patch 28 will have to move earlier
> in series though.

Yes, I think it makes sense to move patch 28 earlier.

