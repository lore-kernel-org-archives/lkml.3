Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaLBM7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:59:06 -0500
Received: from h1.radempa.de ([176.9.142.194]:49627 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbaLBM7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:59:03 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: dht11: IRQ fixes
In-reply-to: <547D9A6F.9010801@nod.at>
References: <1417465651-16036-1-git-send-email-richard@nod.at> <1417465651-16036-2-git-send-email-richard@nod.at> <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at> <547D9A6F.9010801@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Tue, 02 Dec 2014 11:54:39 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4603.1417525133.1@stardust.g4.wien.funkfeuer.at>
Date: Tue, 02 Dec 2014 13:58:53 +0100
Message-Id: <E1Xvn2b-0001CH-PM@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
> Harald,
> 
> Am 02.12.2014 um 11:19 schrieb Harald Geyer:
> > Hi Richard,
> > 
> > thanks for the patch.
> > 
> > I think (haven't tried yet) that your patch changes the number of
> > edges recorded per transmission. So probably the decoding function
> > needs to be adapted too...
> 
> Can you explain your thought?
> I'll happily dig into that.

Part of the reason to have the IRQ enabled during output was to
get consistent timestamps (all timestamps would be taken via the
same codepath). While this isn't essential, the current code expects
that the start command we generate is in the list of edges. I think
your changes will cause that start command not to be in the list of
edges.

Note: There have been issues with some sensors (DHT11s?) not to
send proper start bits, so the driver tries to be liberal about
what it expects and you probably haven't seen any decoding errors
if your sample sensor works to specification. (Now that I come to
think about it: Undefined behaviour of IRQs on output lines could
have been involved too...)

This is a bit of a mess and I'd rather clean this up than add more
to it. Maybe I'm overly fussy about this, but it has bitten me in
the past.

Since it seems you have some interesst in working on these parts,
let me mention an unrelated issue: The DHT22 stops sending data
after a random time (think of days here) which AFAIK only can be
worked around by power-cycling the sensor. I mean to add something
for this to the driver but couln't make up my mind about what the
proper ABI for this would be, so right now I'm using some userspace
hack for this. (The issue was already discussed on the linux-iio
mailing list a few month ago, if you want to look into this.
Anyway: You have been warned ... ;)  
 
> > I won't be able to ACK this before testing on real HW. Of course
> > confirmation that your changes work reliably on both DHT11 and DHT22
> > will do as well. The debuging code present in the initial submission
> > of the driver might be helpful to anybody trying to verify the
> > timing.
> 
> I have only DHT22 sensors. Of course I've tested the driver with these.

Ok, so I'll test DHT11 first. It would still be nice to confirm how
many edges are recorded from DHT22 though.

Thanks,
Harald
