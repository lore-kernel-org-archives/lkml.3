Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab3HNWc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:32:59 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:8844 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3HNWc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:32:57 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "mikem@thumper.usa.hp.com" <mikem@thumper.usa.hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "bubrown@redhat.com" <bubrown@redhat.com>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Subject: RE: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
Thread-Topic: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
Thread-Index: AQHOmTUMBJgAlQMRzEuEeNzyVToHo5mVOq6A
Date: Wed, 14 Aug 2013 21:41:14 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32735BD62@G6W2491.americas.hpqcorp.net>
References: <20130814205236.GB23042@beardog.cce.hp.com>
 <1376515627.2028.41.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1376515627.2028.41.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.201.12.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, August 14, 2013 4:27 PM
To: Miller, Mike (OS Dev); mikem@thumper.usa.hp.com
Cc: Andrew Morton; Jens Axboe; LKML-scsi; LKML; thenzl@redhat.com; bubrown@redhat.com; scameron@beardog.cce.hp.com
Subject: Re: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600

On Wed, 2013-08-14 at 15:52 -0500, Mike Miller wrote:
> Patch 1/1
> 
> From: Mike Miller <mike.miller@hp.com>
> 
> At one time we used to set the maximum number of scatter gather 
> elements on all Smart Array controllers to 32. At some point in time 
> the firmware began to write the "appropriate" value for each controller into the config table.
> The cciss driver would then read that and set h->maxsgentries.
> 
>         h->maxsgentries = readl(&(h->cfgtable->MaxSGElements);
> 
> On the P600 that value is 544. Under some workloads a significant 
> performance reduction may result. This patch forces the P600 to use 
> only 32 scatter gather elements. Other controllers are not affected.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Dwight (Bud) Brown <bubrown@redhat.com>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Acked-by: Stephen M. Cameron <steve.cameron@hp.com>

I don't quite understand the signoff chain on this patch.  For a one line patch, are you saying it has three authors?

James

The patch origin is unknown. I got it from Tomas and Bud who think it may have originated from HP. I cleaned it up, compile tested it, and sent it on. I'll review my procedures for future patches.

-- mikem


