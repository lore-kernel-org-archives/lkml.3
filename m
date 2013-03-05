Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3CEBPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:15:31 -0500
Received: from ozlabs.org ([203.10.76.45]:49535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768Ab3CEBP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:15:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
In-Reply-To: <1362141432.3052.28.camel@hornet>
References: <87wqubkalj.fsf@rustcorp.com.au> <1360839247-9131-1-git-send-email-pawel.moll@arm.com> <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet> <51308F22.7040303@arm.com> <1362141432.3052.28.camel@hornet>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 05 Mar 2013 11:11:48 +1100
Message-ID: <87fw0ad7sr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Moll <pawel.moll@arm.com> writes:
> On Fri, 2013-03-01 at 11:21 +0000, Marc Zyngier wrote:
>> > Having said that, Rusty was contemplating enforcing LE config space in
>> > the new PCI layout...
>> 
>> I wouldn't complain about that, and would like to see a similar thing on
>> MMIO.
>
> Wherever PCI goes, MMIO follows :-)

Yes, but if you switch from 'guest-endian' to 'little-endian' how will
you tell?  For PCI, we'd detect it by using the new layout.

I'd rather you specify MMIO as little endian, and we fix the kernel
config accessors to be endian aware (ie. 8, 16, 32, 64-bit accessors).
Since noone BE is using MMIO right now, it's safe...

Thanks,
Rusty.
