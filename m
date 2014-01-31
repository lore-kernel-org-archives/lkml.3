Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaAaIUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:20:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaAaIUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:20:30 -0500
Date: Fri, 31 Jan 2014 03:20:17 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] block devices: validate block device capacity
In-Reply-To: <1391147127.2181.159.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LRH.2.02.1401310316560.21451@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>    <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>    <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>  
 <1391125027.2181.114.camel@dabdike.int.hansenpartnership.com>   <alpine.LRH.2.02.1401301905520.25766@file01.intranet.prod.int.rdu2.redhat.com>  <1391132609.2181.131.camel@dabdike.int.hansenpartnership.com>  <alpine.LRH.2.02.1401302116180.9767@file01.intranet.prod.int.rdu2.redhat.com>
 <1391147127.2181.159.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Jan 2014, James Bottomley wrote:

> > So, if you want 64-bit page offsets, you need to increase pgoff_t size, 
> > and that will increase the limit for both files and block devices.
> 
> No.  The point is the page cache mapping of the device uses a
> manufactured inode saved in the backing device. It looks fixable in the
> buffer code before the page cache gets involved.

So if you think you can support 16TiB devices and leave pgoff_t 32-bit, 
send a patch that does it.

Until you make it, you should apply the patch that I sent, that prevents 
kernel lockups or data corruption when the user uses 16TiB device on 
32-bit kernel.

Mikulas
