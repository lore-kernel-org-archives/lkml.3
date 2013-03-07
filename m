Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3CGHEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:04:50 -0500
Received: from ozlabs.org ([203.10.76.45]:60166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab3CGHEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:04:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
In-Reply-To: <1362582615.3105.45.camel@hornet>
References: <87wqubkalj.fsf@rustcorp.com.au> <1360839247-9131-1-git-send-email-pawel.moll@arm.com> <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet> <51308F22.7040303@arm.com> <1362141432.3052.28.camel@hornet> <87fw0ad7sr.fsf@rustcorp.com.au> <1362582615.3105.45.camel@hornet>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Mar 2013 17:36:13 +1100
Message-ID: <871ubryaw2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Moll <pawel.moll@arm.com> writes:
> On Tue, 2013-03-05 at 00:11 +0000, Rusty Russell wrote:
>> Pawel Moll <pawel.moll@arm.com> writes:
>> > On Fri, 2013-03-01 at 11:21 +0000, Marc Zyngier wrote:
>> >> > Having said that, Rusty was contemplating enforcing LE config space in
>> >> > the new PCI layout...
>> >> 
>> >> I wouldn't complain about that, and would like to see a similar thing on
>> >> MMIO.
>> >
>> > Wherever PCI goes, MMIO follows :-)
>> 
>> Yes, but if you switch from 'guest-endian' to 'little-endian' how will
>> you tell?  For PCI, we'd detect it by using the new layout.
>
> The version register/value. At some point of time there will be a
> new(ish) MMIO layout anyway to deal with 64-bit addresses, replacing the
> ring page number with two 32-bit hi/lo physical address registers. This
> was discussed not long after the driver got merged...

As long as you have a plan for older guests...

>> I'd rather you specify MMIO as little endian, and we fix the kernel
>> config accessors to be endian aware (ie. 8, 16, 32, 64-bit accessors).
>> Since noone BE is using MMIO right now, it's safe...
>
> That's absolutely fine with me, however I don't see anything I could do
> in the virtio_mmio driver and spec - the virtio_config_ops specifies
> get/set as void * operations and I simply do byte-by-byte copy. Have I
> missed some config/endianess/PCI related discussion?

Yes, that's exactly what I mean, they'd have to be split into
8/16/32/64 accessors.  Which would do byte-by-byte for PCI.

The spec can simply be updated.

Cheers,
Rusty.
