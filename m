Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbaIWO64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:58:56 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:30966 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaIWO6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:58:50 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: boot stall regression due to blk-mq: use percpu_ref for mq
 usage count
Thread-Topic: boot stall regression due to blk-mq: use percpu_ref for mq
 usage count
Thread-Index: AQHP1vVZ6AtrV49KnkCk3Df2Q45vT5wOy7XQ
Date: Tue, 23 Sep 2014 14:57:48 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C94862@G9W0745.americas.hpqcorp.net>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org>
In-Reply-To: <20140923061152.GI11740@mtj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Tejun Heo
> Sent: Tuesday, 23 September, 2014 1:12 AM
> To: Christoph Hellwig
> Cc: Jens Axboe; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
> count
> 
> On Tue, Sep 23, 2014 at 08:09:06AM +0200, Christoph Hellwig wrote:
> > On Tue, Sep 23, 2014 at 02:01:41AM -0400, Tejun Heo wrote:
> > > On Tue, Sep 23, 2014 at 07:59:24AM +0200, Christoph Hellwig wrote:
> > > > "[PATCHSET percpu/for-3.18] percpu_ref: implement
> switch_to_atomic/percpu()"
> > > >
> > > > looks way to big for 3.17, and the regression was introduced in the
> 3.17
> > > > merge window.  I'm not sure what was broken before, but it defintively
> > > > survived a lot of testing.
> > >
> > > Do we even care about fixing it for 3.17?  scsi-mq isn't enabled by
> > > default even for 3.18.  The open-coded percpu ref thing was subtly
> > > broken there.  It'd be difficult to trigger but I'm fairly sure it'd
> > > crap out in the wild once in a blue moon.
> >
> > It's compiled in by default, and people are extremly eager to test it.
> 
> Ugh, I don't know.  It's not like we have a very good baseline we can
> go back to and reverting it for -stable and then redoing it seems
> kinda excessive for a yet experimental feature.  Jens?

scsi_mod.use_blk_mq is not listed in 3.17rc6 Documentation/kernel-
parameters.txt or Documentation/scsi/scsi-parameters.txt (which
does admit "This document may not be entirely up to date and
comprehensive.").

Perhaps a description with an "experimental" warning could be 
slipped into scsi-parameters.txt in 3.17, with plans to remove
that warning in 3.18.

---
Rob Elliott    HP Server Storage



