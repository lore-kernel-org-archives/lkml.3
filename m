Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaLAMDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:03:13 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:50719 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaLAMDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:03:11 -0500
Date: Mon, 1 Dec 2014 13:02:58 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201130258.6f01c1e3.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201114645.GA17505@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
	<20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
	<20141201114645.GA17505@redhat.com>
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
x-cbid: 14120112-0009-0000-0000-000002354617
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 13:46:45 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> > On Mon, 1 Dec 2014 11:26:58 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > For some places on data path, it might be worth it
> > > to cache the correct value e.g. as part of device
> > > structure. This replaces a branch with a memory load,
> > > so the gain would have to be measured, best done
> > > separately?
> > 
> > I think we'll want to do some measuring once the basic structure is
> > in place anyway.
> 
> What's meant by in place here?

That this patchset is ready :)

> 
> > We should make sure that e.g. s390 only takes minor
> > hit due to all that swapping that is needed for standard-compliant
> > devices. Caching the value might certainly help in some paths.
> 
> Well, this is queued in linux-next for 3.19, so
> now's the time to do it :)

So much to do, so little time...

I'm still feeling a bit uncomfortable with some of the changes
(virtio-scsi etc.) as I have not been able to test them yet (as there's
no converted qemu for these yet). The virtio-net and virtio-blk changes
seem sane, though, and virtio-ccw should be fine as well.

OTOH, it's not like we're introducing new external interfaces, so later
rework should be fine.

