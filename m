Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab3HNV1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:27:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34636 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933121Ab3HNV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:27:09 -0400
Message-ID: <1376515627.2028.41.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: mike.miller@hp.com, mikem@thumper.usa.hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, thenzl@redhat.com,
        bubrown@redhat.com, scameron@beardog.cce.hp.com
Date: Wed, 14 Aug 2013 14:27:07 -0700
In-Reply-To: <20130814205236.GB23042@beardog.cce.hp.com>
References: <20130814205236.GB23042@beardog.cce.hp.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 15:52 -0500, Mike Miller wrote:
> Patch 1/1
> 
> From: Mike Miller <mike.miller@hp.com>
> 
> At one time we used to set the maximum number of scatter gather elements on 
> all Smart Array controllers to 32. At some point in time the firmware began 
> to write the "appropriate" value for each controller into the config table. 
> The cciss driver would then read that and set h->maxsgentries.
> 
>         h->maxsgentries = readl(&(h->cfgtable->MaxSGElements);
> 
> On the P600 that value is 544. Under some workloads a significant 
> performance reduction may result. This patch forces the P600 to use only 32 
> scatter gather elements. Other controllers are not affected.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Dwight (Bud) Brown <bubrown@redhat.com>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Acked-by: Stephen M. Cameron <steve.cameron@hp.com>

I don't quite understand the signoff chain on this patch.  For a one
line patch, are you saying it has three authors?

James


