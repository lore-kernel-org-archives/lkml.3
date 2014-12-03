Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaLCO1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:27:42 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:34648 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaLCO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:27:40 -0500
Date: Wed, 3 Dec 2014 15:27:27 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0
 endian-ness
Message-ID: <20141203152727.5b4d3e34.cornelia.huck@de.ibm.com>
In-Reply-To: <20141203140228.GA12370@redhat.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
	<20141202193930.2b8750f7.cornelia.huck@de.ibm.com>
	<20141203140228.GA12370@redhat.com>
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
x-cbid: 14120314-0041-0000-0000-000002592558
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 16:02:28 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Dec 02, 2014 at 07:39:30PM +0100, Cornelia Huck wrote:
> > On Tue, 2 Dec 2014 13:44:06 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
> > > to make it handle endian-ness exactly as other virtio 1.0 devices: what
> > > we gain from this, is that there's no need to special-case it in virtio
> > > core.
> > 
> > Well, the balloon is weird in a number of ways, including its always
> > little-endian config space.
> 
> Hmm yes, I forgot about that.
> 
> > But I'm not quite sure the spec covers this?
> 
> The spec does not cover balloon.  It merely includes a reference section
> about legacy balloon device.  What to do when that device sets VERSION_1
> is really up to us.
> 
> Patchset v8 simply makes balloon tell core it's legacy_only.
> This is I guess fine as far as it goes.
> I was still looking for the best way that involves minimal noise
> in core. This looked like the best way: change 4 lines,
> and drop all special casing in core, but given the config space
> endian-ness mess, I'm not sure anymore.
> I guess we'll just stick to what v8 does for now.

I don't think the legacy_only approach is so bad, let's keep it for now.

