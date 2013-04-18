Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966354Ab3DRMoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:44:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965707Ab3DRMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:44:02 -0400
Date: Thu, 18 Apr 2013 05:43:55 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        martin.peterson@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 7/7] xen-block: implement indirect descriptors
Message-ID: <20130418124355.GW4816@kernel.dk>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-8-git-send-email-roger.pau@citrix.com>
 <20130409184923.GA4978@phenom.dumpdata.com>
 <516C3264.3050409@citrix.com>
 <20130417142554.GG21378@phenom.dumpdata.com>
 <516ED633.3040205@citrix.com>
 <20130417172747.GA25736@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130417172747.GA25736@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 17, 2013 at 07:04:51PM +0200, Roger Pau Monné wrote:
> > On 17/04/13 16:25, Konrad Rzeszutek Wilk wrote:
> > >>> Perhaps the xen-blkfront part of the patch should be just split out to make
> > >>> this easier?
> > >>>
> > >>> Perhaps what we really should have is just the 'max' value of megabytes
> > >>> we want to handle on the ring.
> > >>>
> > >>> As right now 32 ring requests * 32 segments = 4MB.  But if the user wants
> > >>> to se the max: 32 * 4096 = so 512MB (right? each request would handle now 16MB
> > >>> and since we have 32 of them = 512MB).
> > >>
> > >> I've just set that to something that brings a performance benefit
> > >> without having to map an insane number of persistent grants in blkback.
> > >>
> > >> Yes, the values are correct, but the device request queue (rq) is only
> > >> able to provide read requests with 64 segments or write requests with
> > >> 128 segments. I haven't been able to get larger requests, even when
> > >> setting this to 512 or higer.
> > > 
> > > What are you using to drive the requests? 'fio'?
> > 
> > Yes, I've tried fio with several "bs=" values, but it doesn't seem to
> > change the size of the underlying requests. Have you been able to get
> > bigger requests?
> 
> Martin, Jens,
> Any way to drive more than 128 segments?

If the driver is bio based, then there's a natural size constraint on
the number of vecs in the bio. So to get truly large requests, the
driver would need to merge incoming sequential IOs (similar to how it's
done for rq based drivers).

-- 
Jens Axboe

