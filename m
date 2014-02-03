Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaBCIPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:15:13 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBCIPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:15:11 -0500
Date: Mon, 3 Feb 2014 00:15:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] block devices: validate block device capacity
Message-ID: <20140203081506.GA10961@infradead.org>
References: <alpine.LRH.2.02.1401301531040.29912@file01.intranet.prod.int.rdu2.redhat.com>
 <1391122163.2181.103.camel@dabdike.int.hansenpartnership.com>
 <alpine.LRH.2.02.1401301805590.19506@file01.intranet.prod.int.rdu2.redhat.com>
 <1391125027.2181.114.camel@dabdike.int.hansenpartnership.com>
 <alpine.LRH.2.02.1401301905520.25766@file01.intranet.prod.int.rdu2.redhat.com>
 <1391132609.2181.131.camel@dabdike.int.hansenpartnership.com>
 <alpine.LRH.2.02.1401302116180.9767@file01.intranet.prod.int.rdu2.redhat.com>
 <1391147127.2181.159.camel@dabdike.int.hansenpartnership.com>
 <alpine.LRH.2.02.1401310316560.21451@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401310316560.21451@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:20:17AM -0500, Mikulas Patocka wrote:
> So if you think you can support 16TiB devices and leave pgoff_t 32-bit, 
> send a patch that does it.
> 
> Until you make it, you should apply the patch that I sent, that prevents 
> kernel lockups or data corruption when the user uses 16TiB device on 
> 32-bit kernel.

Exactly.  I had actually looked into support for > 16TiB devices for
a NAS use case a while ago, but when explaining the effort involves
the idea was dropped quickly.  The Linux block device is too deeply
tied to the pagecache to make it easily feasible.

