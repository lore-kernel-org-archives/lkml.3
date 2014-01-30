Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaA3XK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:10:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaA3XKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:10:23 -0500
Date: Thu, 30 Jan 2014 18:10:13 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        Nick Piggin <npiggin@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] block devices: validate block device capacity
In-Reply-To: <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com> <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Jan 2014, James Bottomley wrote:

> Why is this?  the whole reason for CONFIG_LBDAF is supposed to be to
> allow 64 bit offsets for block devices on 32 bit.  It sounds like
> there's somewhere not using sector_t ... or using it wrongly which needs
> fixing.

The page cache uses unsigned long as a page index. Therefore, if unsigned 
long is 32-bit, the block device may have at most 2^32-1 pages.

> > On 32-bit architectures, we must limit block device size to
> > PAGE_SIZE*(2^32-1).
> 
> So you're saying CONFIG_LBDAF can never work, why?
> 
> James

CONFIG_LBDAF works, but it doesn't allow unlimited capacity: on x86, 
without CONFIG_LBDAF, the limit is 2TiB. With CONFIG_LBDAF, the limit is 
16TiB (4096*2^32).

Mikulas
