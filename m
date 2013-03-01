Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3CAKuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:50:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40770 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAKuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:50:07 -0500
Message-ID: <1362135005.3052.26.camel@hornet>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
From: Pawel Moll <pawel.moll@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Fri, 01 Mar 2013 10:50:05 +0000
In-Reply-To: <513085EA.8070007@arm.com>
References: <87wqubkalj.fsf@rustcorp.com.au>
	 <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
	 <513085EA.8070007@arm.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Mar 2013 10:50:06.0695 (UTC) FILETIME=[89588F70:01CE166A]
X-MC-Unique: 113030110500603501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 10:41 +0000, Marc Zyngier wrote:
> On 14/02/13 10:54, Pawel Moll wrote:
> > To solve the never-ending confusions between hosts and guests
> > of different endianess, define all virtio-mmio registers as LE.
> > 
> > This change should be safe at this stage, because no known
> > working mixed-endian system exists so there is virtually no
> > risk of breaking compatibility.
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>
> Shouldn't we exclude the config space? PCI defines it as guest-endian,
> and the above tends to indicate that it should be LE with MMIO.

The spec says: "Device-specific configuration space starts at an offset
0x100 and is accessed with byte alignment. Its meaning and size depends
on the device and the driver."

I would hope that "accessed with byte alignment" is enough of a clue in
this subject, but if you think otherwise I can add a sentence stating
this explicitly.

Having said that, Rusty was contemplating enforcing LE config space in
the new PCI layout...

Paweł


