Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3CFPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:10:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46629 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab3CFPKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:10:20 -0500
Message-ID: <1362582615.3105.45.camel@hornet>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 06 Mar 2013 15:10:15 +0000
In-Reply-To: <87fw0ad7sr.fsf@rustcorp.com.au>
References: <87wqubkalj.fsf@rustcorp.com.au>
	 <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
	 <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet>
	 <51308F22.7040303@arm.com> <1362141432.3052.28.camel@hornet>
	 <87fw0ad7sr.fsf@rustcorp.com.au>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Mar 2013 15:10:15.0714 (UTC) FILETIME=[B51C9820:01CE1A7C]
X-MC-Unique: 113030615101731401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 00:11 +0000, Rusty Russell wrote:
> Pawel Moll <pawel.moll@arm.com> writes:
> > On Fri, 2013-03-01 at 11:21 +0000, Marc Zyngier wrote:
> >> > Having said that, Rusty was contemplating enforcing LE config space in
> >> > the new PCI layout...
> >> 
> >> I wouldn't complain about that, and would like to see a similar thing on
> >> MMIO.
> >
> > Wherever PCI goes, MMIO follows :-)
> 
> Yes, but if you switch from 'guest-endian' to 'little-endian' how will
> you tell?  For PCI, we'd detect it by using the new layout.

The version register/value. At some point of time there will be a
new(ish) MMIO layout anyway to deal with 64-bit addresses, replacing the
ring page number with two 32-bit hi/lo physical address registers. This
was discussed not long after the driver got merged...

> I'd rather you specify MMIO as little endian, and we fix the kernel
> config accessors to be endian aware (ie. 8, 16, 32, 64-bit accessors).
> Since noone BE is using MMIO right now, it's safe...

That's absolutely fine with me, however I don't see anything I could do
in the virtio_mmio driver and spec - the virtio_config_ops specifies
get/set as void * operations and I simply do byte-by-byte copy. Have I
missed some config/endianess/PCI related discussion?

Paweł


